module Group
  
  class ValidatePostTitle < UseCase::Validator

    target :post

    validates_presence_of :title

  end

  class ValidatePostBody < UseCase::Validator

    target :post

    validates_presence_of :body

  end

  class ValidateDependsAll < UseCase::DependsAll

    depends ValidatePostTitle, ValidatePostBody

  end
end
