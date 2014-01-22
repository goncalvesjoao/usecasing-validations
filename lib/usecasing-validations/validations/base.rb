module UseCase
  module Validations

    module Base

      def self.included(base)
        base.extend(HelperMethods)
        base.extend(ClassMethods)
      end

      def run_validations!(object_to_validate)
        self.class.validators.each do |validator|
          if validator.options.key?(:if)
            next unless send(validator.options[:if])
          end

          validator.validate(object_to_validate)
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
          args << options
          validates_with(*args, &block)
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

            # validate(validator, options)
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
