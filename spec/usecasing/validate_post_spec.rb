require 'spec_helper'

describe ValidatePost do 

  it "'#validates_presence_of' on a ruby object" do

    post = RubyPost.new({ title: "title", body: "body" })
    context = ValidatePost.perform(post: post)
    post.errors.empty?.should == true
    context.success?.should == true

    post = RubyPost.new({ body: "body" })
    context = ValidatePost.perform(post: post)
    post.errors.size.should == 1
    post.errors.empty?.should == false
    context.success?.should == false

    post = RubyPost.new
    context = ValidatePost.perform(post: post)
    post.errors.size.should == 2
    post.errors.empty?.should == false
    context.success?.should == false

  end
  
end

