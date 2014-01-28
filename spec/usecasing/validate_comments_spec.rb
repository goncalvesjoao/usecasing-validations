require 'spec_helper'

describe ValidateComments do 

  it "#validates_presence_of and #validates_format_of on multiple instances of 'RubyComment' inside a 'RubyPost'" do

    post = RubyPostWithComments.new([{ title: "title1", email: "teste1@gmail.com" }, { title: 'title2', email: 'teste2@gmail.com' }])
    context = ValidateComments.perform(post: post)

    context.success?.should == true

    comment1 = post.comments[0]
    comment1.errors.empty?.should == true
    comment2 = post.comments[1]
    comment2.errors.empty?.should == true

    
    post = RubyPostWithComments.new([{ title: "title1", email: "teste1@gmail.com" }, { title: 'title2', email: 'fakemail' }, { email: 'teste3@gmail.com' }])
    context = ValidateComments.perform(post: post)

    context.success?.should == false

    comment1 = post.comments[0]
    comment1.errors.empty?.should == true

    comment2 = post.comments[1]
    comment2.errors.added?(:email, "invalid format!").should == true
    comment2.errors.size.should == 1

    comment3 = post.comments[2]
    comment3.errors.added?(:title, "can't be blank!").should == true
    comment3.errors.size.should == 1

  end

  it "#validates_length_of on multiple instances of 'RubyComment' inside a 'RubyPost'" do

    post = RubyPostWithComments.new([{ title: 'small', email: 'teste4@gmail.com' }])
    context = ValidateComments.perform(post: post)

    context.success?.should == false

    comment1 = post.comments[0]
    comment1.errors.added?(:title, :too_short).should == true
    comment1.errors.size.should == 1

  end
  
  it "#validate on multiple instances of 'RubyComment' inside a 'RubyPost'" do

    post = RubyPostWithComments.new([{ title: 'force_error1', email: 'teste4@gmail.com' }, { title: 'force_error2', email: 'force_error@gmail.com' }])
    context = ValidateComments.perform(post: post)

    context.success?.should == false

    comment1 = post.comments[0]
    comment1.errors.added?(:title, 'custom_validation1').should == true
    comment1.errors.size.should == 1

    comment2 = post.comments[1]
    comment2.errors.added?(:title, 'custom_validation1').should == true
    comment2.errors.added?(:email, 'custom_validation2').should == true
    comment2.errors.size.should == 2

  end

  it "validating a empty target" do

    post = RubyPostWithComments.new
    context = ValidateComments.perform(post: post)

    context.success?.should == true

  end

end

