module UseCaseValidations
  
  module Target

    def self.included(base)
      base.extend(ClassMethods)
    end

    def target
      send(self.class.target_sym)
    end

    def parent_target
      self.class.options.key?(:in) ? send(self.class.options[:in]) : nil
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
