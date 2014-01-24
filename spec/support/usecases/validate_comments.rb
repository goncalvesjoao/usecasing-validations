class ValidateComments < UseCase::Validator

  target :comments, in: :post

  validates_presence_of :title, message: "can't be blank!"
  
  validates_format_of :email, with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, message: "invalid format!"

  validates_length_of :title, minimum: 6, allow_nil: true

  validate :custom_validation1, :custom_validation2


  protected ######################### PROTECTED ############################

  def custom_validation1(comment)
    if ['force_error1', 'force_error2'].include?(comment.title)
      comment.errors.add(:title, 'custom_validation1')
      return false
    end

    true
  end

  def custom_validation2(comment)
    if comment.email == "force_error@gmail.com"
      comment.errors.add(:email, 'custom_validation2')
      return false
    end

    true
  end

end