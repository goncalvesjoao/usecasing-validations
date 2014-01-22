class ValidateComments < UseCase::Validator
  
  def target
    context.post.comments
  end

  validates_presence_of :title, message: "can't be blank!"
  
  validates_format_of :email, with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, message: "invalid format!"

end