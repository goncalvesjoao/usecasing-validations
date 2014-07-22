module UseCaseValidations

  module Target

    def self.included(base)
      base.extend(ClassMethods)
    end

    def parent_target_name
      self.class.options.key?(:in) ? self.class.options[:in] : nil
    end

    def target
      send(self.class.target_name)
    end

    def parent_target
      parent_target_name ? send(parent_target_name) : nil
    end

    module ClassMethods

      def target_name
        Helpers._get_instance_variable(self, :target_name, nil)
      end

      def options
        Helpers._get_instance_variable(self, :options, {})
      end

      def target(target_name, options = {})
        @target_name, @options = target_name, options

        if options.key?(:in)
          define_method(options[:in]) { context.send(options[:in]) }
          define_method(target_name) { send(options[:in]).send(target_name) }
        else
          define_method(target_name) { context.send(target_name) }
        end
      end

    end

  end

end
