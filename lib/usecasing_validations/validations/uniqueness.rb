module UseCaseValidations
  module Validations

    class UniquenessValidator < EachValidator
      def validate_each(record, attribute, value)

        records.each do |other_record|
          next if record == other_record || Helpers._marked_for_destruction?(other_record) || !scope_method(record)

          if similar_objects?(record, other_record, attribute)
            record.errors.add(attribute, :taken, options)
            break
          end
        end

      end

      protected ########################### PROTECTED #######################

      def records
        [*base.target].inject([]) do |scoped_list, object|
          scoped_list << object if scope_method(object)
          scoped_list
        end
      end

      def similar_objects?(record, other_record, attribute)
        if options.key?(:conditions)
          if base.method(options[:conditions]).arity == 3
            base.send(options[:conditions], record, other_record, attribute)
          else
            base.send(options[:conditions], record, other_record)
          end
        else
          record.send(attribute) == other_record.send(attribute)
        end
      end

      private ###################### PRIVATE ####################

      def scope_method(object)
        options.key?(:scope) ? base.send(options[:scope], object) : true
      end

    end

    module HelperMethods
      def validates_uniqueness_of(*attr_names)
        validates_with UniquenessValidator, _merge_attributes(attr_names)
      end
    end
  
  end
end
