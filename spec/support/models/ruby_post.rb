class RubyPost

  attr_accessor :title, :body

  def initialize(attributes = {})
    (attributes || {}).each { |name, value| send("#{name}=", value) }
  end

end
