require 'spec_helper'

describe ValidateComments do 

  it "Multiple validations on a list of ruby objects: 'RubyComment' inside another ruby object: 'RubyPost'", current: true do

    post = RubyPostWithComments.new([{ title: "title1", email: "teste1@gmail.com" }, { title: 'title2', email: 'teste2@gmail.com' }])
    context = ValidateComments.perform(post: post)

    context.success?.should == true

    comment1 = post.comments[0]
    comment1.errors.empty?.should == true
    comment2 = post.comments[1]
    comment2.errors.empty?.should == true

    
    post = RubyPostWithComments.new([{ title: "title1", email: "teste1@gmail.com" }, { title: 'title2', email: 'fakemail' }, { email: 'teste2@gmail.com' }])
    context = ValidateComments.perform(post: post)

    context.success?.should == false

    comment1 = post.comments[0]
    comment1.errors.empty?.should == true

    comment2 = post.comments[1]
    comment2.errors.include?(:email)
    comment2.errors.size.should == 1

    comment3 = post.comments[2]
    comment3.errors.include?(:title)
    comment3.errors.size.should == 1

  end
  
end

