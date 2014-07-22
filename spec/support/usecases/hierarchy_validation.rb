module HierarchyValidation

  class Father < UseCase::Validator

    target :post

    validates_presence_of :title

  end

  class Son < Father

    target :comments, in: :post

    validates_presence_of :email

  end

end