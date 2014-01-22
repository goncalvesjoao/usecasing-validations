class ValidatePost < UseCase::Validator
  
  target :post

  validates_presence_of :title, :body, message: "can't be blank!"

end