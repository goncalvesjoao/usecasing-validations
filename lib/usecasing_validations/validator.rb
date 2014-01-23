module UseCaseValidations
  
  class Validator

    attr_reader :options
    attr_accessor :base

    def initialize(options = {})
      @options  = Helpers._except(options, :class).freeze
    end

    # Override this method in subclasses with validation logic, adding errors
    # to the records +errors+ array where necessary.
    def validate(record)
      raise NotImplementedError, "Subclasses must implement a validate(record) method."
    end
    
  end

end
