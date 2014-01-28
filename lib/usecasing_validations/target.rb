module UseCaseValidations
  
  module Target

    def self.included(base)
      base.extend(ClassMethods)
    end

    def target_sym
      self.class.target_sym
    end

    def parent_target_sym
      self.class.options.key?(:in) ? self.class.options[:in] : nil
    end

    def target
      send(target_sym)
    end

    def parent_target
      parent_target_sym ? send(parent_target_sym) : nil
    end

    module ClassMethods

      attr_reader :target_sym, :options
      
      def target(target_sym, options = {})
        @target_sym, @options = target_sym, options

        if options.key?(:in)
          define_method(options[:in]) { context.send(options[:in]) }
          define_method(target_sym) { send(options[:in]).send(target_sym) }
        else
          define_method(target_sym) { context.send(target_sym) }
        end
      end

    end
    
  end

end
