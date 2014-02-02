require 'usecasing'

require "usecasing_validations/target"
require "usecasing_validations/helpers"
require "usecasing_validations/errors"
require "usecasing_validations/validator"
require "usecasing_validations/each_validator"
require "usecasing_validations/custom_validator"

require "usecasing_validations/validations/helper_methods"
require "usecasing_validations/validations/format"
require "usecasing_validations/validations/length"
require "usecasing_validations/validations/presence"
require "usecasing_validations/validations/uniqueness"


module UseCase
  
  class Base

    def self.depends_all(*deps)
      @dependencies ||= []
      @dependencies.push(*deps)
      ignored_dependencies.push(*deps)
    end

    def self.ignored_dependencies
      @ignored_dependencies ||= []
    end

    def self.not_ignored(usecase)
      !ignored_dependencies.include?(usecase)
    end
  
    def self.tx(execution_order, context)
      ctx = Context.new(context)
      executed = []
      execution_order.each do |usecase|
        break if not_ignored(usecase) && !ctx.success?
        executed.push(usecase)
        yield usecase, ctx
      end
      rollback(executed, ctx) unless ctx.success?
      ctx
    end

  end

  autoload :Validator, 'usecasing/validator'
end


module UseCaseValidations

  def self.included(base)
    base.extend(Validations::HelperMethods)
    base.class_eval { include Target }
    base.extend(ClassMethods)
  end

  protected #################### PROTECTED ######################

  def run_validations!(object_to_validate)
    self.class.validators.each do |validator|
      next unless option_if_succeeds(validator, object_to_validate)

      validator.base = self
      validator.validate(object_to_validate)
    end
  end

  def valid?(object_to_validate)
    extend_errors_if_necessary object_to_validate

    object_to_validate.errors.clear if self.class.clear_errors?

    run_validations! object_to_validate

    object_to_validate.errors.empty?
  end
  
  private ######################## PRIVATE #######################

  def extend_errors_if_necessary(object_to_validate)
    return true if object_to_validate.respond_to?(:errors)

    object_to_validate.instance_eval do
      def errors; @errors ||= Errors.new(self); end
    end
  end

  def option_if_succeeds(validator, object_to_validate)
    if validator.options.key?(:if)
      Helpers._call_proc_or_method(self, validator.options[:if], object_to_validate)
    else
      true
    end
  end

  module ClassMethods

    def clear_errors!
      @clear_errors = true
    end

    def clear_errors?
      defined?(@clear_errors) ? @clear_errors : false
    end

    def _validators
      @_validators ||= Hash.new { |h,k| h[k] = [] }
    end

    def _validators=(value)
      @_validators = value
    end

    def validate(*args, &block)
      _validators[nil] << CustomValidator.new(args, &block)
    end

    def validates_with(*args, &block)
      options = Helpers._extract_options!(args)
      options[:class] = self
      
      args.each do |klass|
        validator = klass.new(options, &block)

        if validator.respond_to?(:attributes) && !validator.attributes.empty?
          validator.attributes.each do |attribute|
            _validators[attribute.to_sym] << validator
          end
        else
          _validators[nil] << validator
        end
      end
    end

    def validators
      _validators.values.flatten.uniq
    end

    # Copy validators on inheritance.
    def inherited(base)
      dup = _validators.dup
      base._validators = dup.each { |k, v| dup[k] = v.dup }
      super
    end

  end #/ClassMethods

end
