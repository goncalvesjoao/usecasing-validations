require 'spec_helper'

describe ValidatePost do 

  it "'#validates_presence_of' on a ruby object" do

    post = RubyPost.new({ title: "title", body: "body" })
    context = ValidatePost.perform(post: post)
    post.errors.empty?.should == true
    context.success?.should == true

    post = RubyPost.new({ body: "body" })
    context = ValidatePost.perform(post: post)
    context.success?.should == false
    post.errors.added?(:title, "can't be blank!").should == true
    post.errors.size.should == 1

    post = RubyPost.new
    context = ValidatePost.perform(post: post)
    context.success?.should == false
    post.errors.added?(:title, "can't be blank!").should == true
    post.errors.added?(:body, "can't be blank!").should == true
    post.errors.size.should == 2

  end

  it "'#validates_format_of' on a ruby object with the 'if' options" do

    post = RubyPost.new({ title: "title", body: "body" })
    context = ValidatePost.perform(post: post)
    post.errors.empty?.should == true
    context.success?.should == true

    context = ValidatePost.perform(post: post, validate_phone_number: true)
    context.success?.should == false
    post.errors.added?(:phone_number, :blank).should == true
    post.errors.size.should == 1

    post = RubyPost.new({ title: "title", body: "body", phone_number: '9 s' })
    context = ValidatePost.perform(post: post, validate_phone_number: true)
    context.success?.should == false
    post.errors.added?(:phone_number, "invalid format!").should == true
    post.errors.size.should == 1

    post = RubyPost.new({ title: "title", body: "body", phone_number: '9 1' })
    context = ValidatePost.perform(post: post, validate_phone_number: true)
    context.success?.should == true
    post.errors.empty?.should == true

  end

end

