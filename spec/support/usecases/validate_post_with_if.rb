class ValidatePostWithIf < UseCase::Validator
  
  target :post

  validates_presence_of :title, message: "can't be blank!", if: ->{ should_validate }

  validates_presence_of :body, message: "can't be blank!", if: :should_validate

  def should_validate
    context.should_validate.nil? ? true : context.should_validate
  end

end