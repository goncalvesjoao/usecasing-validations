require 'spec_helper'

describe Group::ValidateDependsAll do 

  it "Validating multiple UseCase:Validators at the same time without one interrupting the other" do

    post = RubyPost.new
    context = Group::ValidateDependsAll.perform(post: post)
    context.success?.should == false
    post.errors.added?(:title, :blank).should == true
    post.errors.added?(:body, :blank).should == true
    post.errors.size.should == 2

    post2 = RubyPost.new(title: 'title', body: 'body')
    context = Group::ValidateDependsAll.perform(post: post2)
    context.success?.should == true
    post2.errors.empty?.should == true
    
  end

end

