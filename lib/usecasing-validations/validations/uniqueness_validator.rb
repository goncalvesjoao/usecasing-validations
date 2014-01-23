module UseCase
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
        if options.key?(:records)
          HelperMethods._call_proc_or_method(base, options[:records])
        else
          [*base.target]
        end
      end

      def similar_objects?(record, other_record, attr_or_method)
        if base.respond_to?(attr_or_method)
          base.send(attr_or_method, record, other_record)
        else
          record.send(attr_or_method) == other_record.send(attr_or_method)
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
