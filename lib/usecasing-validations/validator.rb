require "usecasing-validations/validations/base"
require "usecasing-validations/validations/errors"
require "usecasing-validations/validations/helper_methods"
require "usecasing-validations/validations/validator"

require "usecasing-validations/validations/presence_validator"
require "usecasing-validations/validations/format_validator"

module UseCase
  
  class Validator < Base

    include Validations::Base
    
    def perform
      all_validations_green = [*target].map do |object_to_validate|
        if object_to_validate.marked_for_destruction?
          true
        else
          valid?(object_to_validate)
        end
      end.all?

      failure(self.class.to_s.downcase.to_sym, :failed) unless all_validations_green
    end

    protected ########################## PROTECTED ###################

    def self.target(object_sym)
      if object_sym.is_a?(Symbol)
        define_method(:target) { context.send(object_sym) }
      else
        binding.pry
      end
    end

    def valid?(object_to_validate)
      object_to_validate.extend(Validations::IncorporateErrors) unless object_to_validate.respond_to?(:errors)

      run_validations!(target)

      target.errors.empty?
    end

  end

end