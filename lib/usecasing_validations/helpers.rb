module UseCaseValidations

  module Helpers

    extend self

    def _super_method(object, method_name, *args)
      if object.superclass.respond_to?(method_name)
        object.superclass.send(method_name, *args)
      end
    end

    def _get_instance_variable(object, variable, default_value)
      instance_var = object.instance_variable_get("@#{variable}")

      return instance_var unless instance_var.nil?

      instance_var = (_super_method(object, variable) || default_value)

      if instance_var.class == Class
        object.instance_variable_set("@#{variable}", instance_var)
      else
        object.instance_variable_set("@#{variable}", _duplicate(instance_var))
      end
    end

    def _duplicate(object)
      object.dup rescue object
    end

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

    def _slice(hash, *keys)
      _hash = {}
      keys.each { |key| _hash[key] = hash[key] }
      _hash
    end

    def _call_proc_or_method(base, proc_or_method, object = nil)
      if object.nil?
        proc_or_method.is_a?(Proc) ? base.instance_exec(&proc_or_method) : base.send(proc_or_method)
      else
        proc_or_method.is_a?(Proc) ? base.instance_exec(object, &proc_or_method) : base.send(proc_or_method, object)
      end
    end

  end

end
