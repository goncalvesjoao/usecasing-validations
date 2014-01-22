class ValidatePost < UseCase::Validator
  
  target :post

  validates_presence_of :title

end