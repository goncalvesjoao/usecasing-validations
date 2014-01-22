module UseCase
  module Validations

    module HelperMethods

      private

      def _merge_attributes(attr_names)
        options = _extract_options!(attr_names).symbolize_keys
        attr_names.flatten!
        options[:attributes] = attr_names
        options
      end
    
      def _extract_options!(array)
        if array.last.is_a?(Hash) && array.last.instance_of?(Hash)
          array.pop
        else
          {}
        end
      end

    end

  end
end
