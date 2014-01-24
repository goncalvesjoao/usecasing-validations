require 'spec_helper'

describe ValidateCommentsCustomTarget do 

  it "validations on a scoped set of instances of 'RubyComment' inside a 'RubyPost'" do

    post = RubyPostWithComments.new([{ title: "title1", email: "teste1@gmail.com" }, { title: 'title2', email: 'teste2@gmail.com' }, { email: "fakemail" }])
    context = ValidateCommentsCustomTarget.perform(post: post)

    context.success?.should == true

    comment1 = post.comments[0]
    comment1.errors.empty?.should == true
    comment2 = post.comments[1]
    comment2.errors.empty?.should == true

    
    post = RubyPostWithComments.new([{ email: "teste1@gmail.com" }, { title: 'title2', email: 'fakemail' }, { email: 'teste3@gmail.com' }])
    context = ValidateCommentsCustomTarget.perform(post: post)

    context.success?.should == false

    comment1 = post.comments[0]
    comment1.errors.added?(:title, :blank).should == true
    comment1.errors.size.should == 1

    comment2 = post.comments[1]
    comment2.errors.added?(:email, :invalid).should == true
    comment2.errors.size.should == 1

    comment3 = post.comments[2]
    comment3.respond_to?(:errors).should == false

  end

end
