require 'spec_helper'

describe UseCase::Validator do 

  it "#methods_to_hash" do
    testing_data = { title: "title", body: "body", email: "fake" }

    object_test1 = Post.new(testing_data)

    context = ValidatePost.perform(object_test1: object_test1)

    context.success?.should == true
  end
  
end

