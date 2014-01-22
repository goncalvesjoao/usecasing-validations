module UseCase
  module Validations

    module HelperMethods

      extend self

      def _blank?(object)
        if object.is_a?(String)
          object !~ /[^[:space:]]/
        else
          object.respond_to?(:empty?) ? object.empty? : !object
        end
      end

      def _marked_for_destruction?(object)
        object.respond_to?(:marked_for_destruction?) ? object.marked_for_destruction? : false
      end

      def _merge_attributes(attr_names)
        options = _symbolyze_keys(_extract_options!(attr_names))
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

      def _symbolyze_keys(hash)
        hash.keys.reduce({ }) do |acc, key|
          acc[key.to_sym] = hash[key]
          acc
        end
      end

      def _except(hash, *keys)
        _hash = hash.dup
        keys.each { |key| _hash.delete(key) }
        _hash
      end

    end

  end
end
