module UseCase
  
  class Validator < Base

    include UseCaseValidations
    
    def perform
      targets = [*target]

      if targets.empty?
        all_validations_green = false
      else
        all_validations_green = targets.map do |object_to_validate|
          if Helpers._marked_for_destruction?(object_to_validate)
            true
          else
            valid?(object_to_validate)
          end
        end.all?
      end

      failure(self.class.to_s.downcase.to_sym, :failed) unless all_validations_green
    end

  end

end
