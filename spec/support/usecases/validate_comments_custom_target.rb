class ValidateCommentsCustomTarget < UseCase::Validator

  def target
    [
      context.post.comments[0],
      context.post.comments[1]
    ]
  end

  validates_presence_of :title
  
  validates_format_of :email, with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

end
