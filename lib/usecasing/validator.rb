module UseCase

  class Validator < ValidatorParent

    include UseCaseValidations

    def perform
      targets = [*target]

      if target.nil?
        all_validations_green = false

      elsif targets.empty?
        all_validations_green = true

      else
        all_validations_green = targets.map do |object_to_validate|
          if Helpers._marked_for_destruction?(object_to_validate)
            true
          else
            valid?(object_to_validate)
          end
        end.all?
      end

      call_failure(:unprocessable_entity, self.class.to_s.downcase.to_sym) unless all_validations_green
    end

  end

end
