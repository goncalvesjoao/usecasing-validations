require 'spec_helper'

describe ValidatePostClearErrors do 

  it "#clean_Errors! will force the #valid? method to clear the target's errors at the start" do

    post = RubyPost.new(body: 'body')
    context = ValidatePostClearErrors.perform(post: post)
    context.success?.should == false
    post.errors.added?(:title, :blank).should == true
    post.errors.size.should == 1

    post.title = 'title'
    post.body = ''
    context = ValidatePostClearErrors.perform(post: post)
    context.success?.should == false
    post.errors.added?(:body, :blank).should == true
    post.errors.size.should == 1

    post.title = ''
    context = ValidatePostClearErrors.perform(post: post)
    context.success?.should == false
    post.errors.added?(:title, :blank).should == true
    post.errors.added?(:body, :blank).should == true
    post.errors.size.should == 2

  end

  it "By default a Validator Class should not clean the target's errors" do

    post = RubyPost.new(body: 'body')
    context = ValidatePost.perform(post: post)
    context.success?.should == false
    post.errors.added?(:title, "can't be blank!").should == true
    post.errors.size.should == 1

    post.title = 'title'
    post.body = ''
    context = ValidatePost.perform(post: post)
    context.success?.should == false
    post.errors.added?(:title, "can't be blank!").should == true
    post.errors.added?(:body, "can't be blank!").should == true
    post.errors.size.should == 2

  end

end

