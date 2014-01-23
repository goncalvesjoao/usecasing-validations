module UseCase
  module Validations

    class UniquenessValidator < EachValidator # :nodoc:
      def validate_each(record, attr_name, value)

        records.each do |other_record|
          next if record == other_record

          if similar_objects?(record, other_record, attr_name)
            record.errors.add(attr_name, :taken, options)
            break
          end
        end

      end

      protected ########################### PROTECTED #######################

      def records
        [*base.target]
      end

      def similar_objects?(record, other_record, attr_name)
        record.send(attr_name) == other_record.send(attr_name)
      end

    end

    module HelperMethods
      def validates_uniqueness_of(*attr_names)
        validates_with UniquenessValidator, _merge_attributes(attr_names)
      end
    end
  
  end
end
