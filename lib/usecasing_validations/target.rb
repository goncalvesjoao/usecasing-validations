module UseCaseValidations
  
  module Target

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      
      def target(object_sym, options = {})
        if options.key?(:in)
          define_method(options[:in]) { context.send(options[:in]) }
          define_method(object_sym) { send(options[:in]).send(object_sym) }
        else
          define_method(object_sym) { context.send(object_sym) }
        end

        define_method(:target) { send(object_sym) }
      end

    end
    
  end

end
