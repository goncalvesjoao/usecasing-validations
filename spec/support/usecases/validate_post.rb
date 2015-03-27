class ValidatePost < UseCase::Validator

  target :post

  validates_presence_of :title, :body, message: "can't be blank!"

  validates_presence_of :phone_number, if: ->(post) { context.validate_phone_number }

  validates_format_of :phone_number, with: /\A[0-9 ]*\z/, message: "invalid format!", if: :validate_phone_number

  validates_numericality_of :phone_number, greater_than: 10

  protected ###################### PROTECTED ####################

  def validate_phone_number(post)
    context.validate_phone_number
  end

end