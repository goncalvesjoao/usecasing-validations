class ValidateUser < UseCase::Validator
  
  target :user

  validates_format_of :email, with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, message: "invalid format!"

end