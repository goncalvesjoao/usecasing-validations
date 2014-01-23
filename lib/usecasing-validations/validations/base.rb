module UseCase
  module Validations

    module Base

      def self.included(base)
        base.extend(HelperMethods)
        base.extend(ClassMethods)
      end

      def run_validations!(object_to_validate)
        object_to_validate.errors.clear if self.class.clear_errors?

        self.class.validators.each do |validator|
          next unless success_of_option_if(validator)

          validator.base = self
          validator.validate(object_to_validate)
        end
      end


      protected #################### PROTECTED ######################

      def success_of_option_if(validator)
        return true unless validator.options.key?(:if)

        if validator.options[:if].is_a?(Proc)
          self.instance_exec(&validator.options[:if])
        else
          send(validator.options[:if])
        end
      end

      def valid?(object_to_validate)
        if !object_to_validate.respond_to?(:errors)
          object_to_validate.instance_eval do
            def errors; @errors ||= Validations::Errors.new(self); end
          end
        end

        run_validations!(object_to_validate)

        object_to_validate.errors.empty?
      end
      

      module ClassMethods

        def clear_errors!
          @clear_errors = true
        end

        def clear_errors?
          defined?(@clear_errors) ? @clear_errors : false
        end

        def target(object_sym, options = {})
          define_method(:target) do
            if options.key?(:in)
              context.send(options[:in]).send(object_sym)
            else
              context.send(object_sym)
            end
          end
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
          options = _extract_options!(args)
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
        def inherited(base) #:nodoc:
          dup = _validators.dup
          base._validators = dup.each { |k, v| dup[k] = v.dup }
          super
        end

      end #/ClassMethods

    end #/Base

  end
end
