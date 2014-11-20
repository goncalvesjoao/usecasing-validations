module UseCase

  class ValidatorParent < Base

    def call_failure(status, message = nil)
      if respond_to?(:failure!)
        failure!(status, message)
      else
        failure(status, message)
      end
    end

  end

end
