module UseCaseValidations
  module Validations

    class UniquenessValidator < EachValidator
      def validate_each(record, attribute, value)

        records.each do |other_record|
          next if record == other_record

          if similar_objects?(record, other_record, attribute)
            record.errors.add(attribute, :taken, options)
            break
          end
        end

      end

      protected ########################### PROTECTED #######################

      def records
        if options.key?(:scope)
          Helpers._call_proc_or_method(base, options[:scope])
        else
          [*base.target]
        end
      end

      def similar_objects?(record, other_record, attribute)
        if options.key?(:conditions)
          base.send(options[:conditions], record, other_record, attribute)
        else
          record.send(attribute) == other_record.send(attribute)
        end
      end

    end

    module HelperMethods
      def validates_uniqueness_of(*attr_names)
        validates_with UniquenessValidator, _merge_attributes(attr_names)
      end
    end
  
  end
end
