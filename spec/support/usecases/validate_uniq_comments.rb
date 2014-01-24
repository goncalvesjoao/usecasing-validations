module ValidateUniqComments

  class Basic < UseCase::Validator

    target :comments, in: :post

    validates_uniqueness_of :title

  end

  class CustomConditions < UseCase::Validator

    validates_uniqueness_of :title, conditions: :similar_conditions

    def similar_conditions(comment, other_comment)
      
    end
    
  end

end
