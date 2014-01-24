class ValidatePostClearErrors < UseCase::Validator
  
  clear_errors!

  target :post

  validates_presence_of :title, :body

end