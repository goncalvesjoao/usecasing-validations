module UseCaseValidations
  module Validations

    module HelperMethods

      def _merge_attributes(attr_names)
        options = Helpers._symbolyze_keys(Helpers._extract_options!(attr_names))
        attr_names.flatten!
        options[:attributes] = attr_names
        options
      end

    end

  end
end
