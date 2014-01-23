module UseCase
  module Validations

    module Base

      def self.included(base)
        base.extend(HelperMethods)
        base.extend(ClassMethods)
      end

      def run_validations!(object_to_validate)
        self.class.validators.each do |validator|
          next unless success_of_option_if(validator)
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

      module ClassMethods

        def _validators
          @_validators ||= Hash.new { |h,k| h[k] = [] }
        end

        def _validators=(value)
          @_validators = value
        end

        def validate(*args, &block)
          options = _extract_options!(args)
          # options[:context] ||= 

          _validators[nil] << CustomValidator.new(args, options)
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
