module ValidateUniqComments

  class Basic < UseCase::Validator

    target :comments, in: :post

    validates_uniqueness_of :title

  end

  class CustomConditions < UseCase::Validator

    target :comments, in: :post

    validates_uniqueness_of :title, conditions: :similar_conditions


    protected ##################### PROTECTED #######################

    def similar_conditions(comment, other_comment)
      comment.title == other_comment.title && comment.email == other_comment.email
    end
    
  end

  class CustomScope < UseCase::Validator

    target :comments, in: :post

    validates_uniqueness_of :title, scope: :belongs_to_post_id1


    protected ##################### PROTECTED #######################

    def belongs_to_post_id1(comment)
      comment.post_id == 1
    end
    
  end

  class CustomScopeAndTarget < UseCase::Validator

    def target
      context.post.first_two_comments
    end

    validates_uniqueness_of :title, scope: :last_two_comments


    protected ##################### PROTECTED #######################

    def last_two_comments(comment)
      [context.post.comments[-1], context.post.comments[-2]].include?(comment)
    end
    
  end

  class CustomScopeAndConditions < UseCase::Validator

    target :comments, in: :post

    validates_uniqueness_of :title, scope: :belongs_to_post_id1, conditions: :similar_conditions


    protected ##################### PROTECTED #######################

    def similar_conditions(comment, other_comment)
      comment.title == other_comment.title && comment.email == other_comment.email
    end

    def belongs_to_post_id1(comment)
      comment.post_id == 1
    end
    
  end

end
