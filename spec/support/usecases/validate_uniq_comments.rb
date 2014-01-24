class ValidateUniqComments < UseCase::Validator

  target :comments, in: :post

  validates_uniqueness_of :title

end