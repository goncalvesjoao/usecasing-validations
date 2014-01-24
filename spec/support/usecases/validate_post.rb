class ValidatePost < UseCase::Validator

  target :post

  validates_presence_of :title, :body, message: "can't be blank!"

  validates_presence_of :phone_number, if: ->{ context.validate_phone_number }
  
  validates_format_of :phone_number, with: /\A[0-9 ]*\z/, message: "invalid format!", if: :validate_phone_number

  
  protected ###################### PROTECTED ####################

  def validate_phone_number
    context.validate_phone_number
  end

end