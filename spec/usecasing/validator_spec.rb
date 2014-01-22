require 'spec_helper'

describe UseCase::Validator do 

  it "'validates_presence_of' on a ruby object" do
    testing_data = { title: "title", body: "body" }

    object_test1 = Post.new(testing_data)

    context = ValidatePost.perform(object_test1: object_test1)

    context.success?.should == true
  end
  
end

