module UseCaseValidations

  class CustomValidator < Validator

    attr_reader :methods

    def initialize(args)
      options = Helpers._extract_options!(args)
      @methods = args
      super(options)
    end

    def validate(record)
      [*methods].map do |method|
        base.send(method, record)
      end.all?
    end
    
  end

end
