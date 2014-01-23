module UseCase
  module Validations
    
    class Validator
      attr_reader :options
      attr_accessor :base

      def initialize(options = {})
        @options  = HelperMethods._except(options, :class).freeze
      end

      # Override this method in subclasses with validation logic, adding errors
      # to the records +errors+ array where necessary.
      def validate(record)
        raise NotImplementedError, "Subclasses must implement a validate(record) method."
      end
    end

    class EachValidator < Validator
      attr_reader :attributes

      def initialize(options)
        @attributes = Array(options.delete(:attributes))
        raise ArgumentError, ":attributes cannot be blank" if @attributes.empty?
        super
        check_validity!
      end

      def validate(record)
        attributes.each do |attribute|
          value = record.send(attribute)
          next if (value.nil? && options[:allow_nil]) || (HelperMethods._blank?(value) && options[:allow_blank])
          validate_each(record, attribute, value)
        end
      end

      # Override this method in subclasses with the validation logic, adding
      # errors to the records +errors+ array where necessary.
      def validate_each(record, attribute, value)
        raise NotImplementedError, "Subclasses must implement a validate_each(record, attribute, value) method"
      end

      def check_validity!; end
    end

    class CustomValidator < Validator
      attr_reader :methods

      def initialize(args)
        options = HelperMethods._extract_options!(args)
        @methods = args
        super(options)
      end

      def validate(record)
        [*methods].map do |method|
          base.send(method, record)
        end.all?
      end
    end

  end
end
