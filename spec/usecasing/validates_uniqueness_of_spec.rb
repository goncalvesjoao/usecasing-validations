require 'spec_helper'

describe 'Several tests to the #validates_uniqueness_of' do 

  it "#validates_uniqueness_of basic usage" do

    post = RubyPostWithComments.new([{ title: 'title1', email: 'teste1@gmail.com' }, { title: 'title1', email: 'teste2@gmail.com' }])
    context = ValidateUniqComments::Basic.perform(post: post)

    context.success?.should == false

    comment1 = post.comments[0]
    comment1.errors.added?(:title, :taken).should == true
    comment1.errors.size.should == 1

    comment2 = post.comments[1]
    comment2.errors.added?(:title, :taken).should == true
    comment2.errors.size.should == 1

  end

  it "#validates_uniqueness_of with a custom conditions" do

    post = RubyPostWithComments.new([{ title: 'title1', email: 'teste1@gmail.com' }, { title: 'title1', email: 'teste1@gmail.com' }, { title: 'title1', email: 'teste2@gmail.com' }])
    context = ValidateUniqComments::CustomConditions.perform(post: post)

    context.success?.should == false

    comment1 = post.comments[0]
    comment1.errors.added?(:title, :taken).should == true
    comment1.errors.size.should == 1

    comment2 = post.comments[1]
    comment2.errors.added?(:title, :taken).should == true
    comment2.errors.size.should == 1

    comment3 = post.comments[2]
    comment3.errors.empty?.should == true

  end

  it "#validates_uniqueness_of with a custom scope" do

    post = RubyPostWithComments.new([{ title: 'title1', post_id: 1 }, { title: 'title1' }])
    context = ValidateUniqComments::CustomScope.perform(post: post)

    context.success?.should == true

    comment1 = post.comments[0]
    comment1.errors.empty?.should == true

    comment2 = post.comments[1]
    comment2.errors.empty?.should == true


    post = RubyPostWithComments.new([{ title: 'title1', post_id: 1 }, { title: 'title1' }, { title: 'title1', post_id: 1 }])
    context = ValidateUniqComments::CustomScope.perform(post: post)

    context.success?.should == false

    comment1 = post.comments[0]
    comment1.errors.added?(:title, :taken).should == true
    comment1.errors.size.should == 1

    comment2 = post.comments[1]
    comment2.errors.empty?.should == true

    comment3 = post.comments[0]
    comment3.errors.added?(:title, :taken).should == true
    comment3.errors.size.should == 1

  end

  it "#validates_uniqueness_of with a custom scope and custom target" do

    post = RubyPostWithComments.new([{ title: 'title1' }, { title: 'title2' }, { title: 'title1' }, { title: 'title3' }, { title: 'title4' }])
    context = ValidateUniqComments::CustomScopeAndTarget.perform(post: post)

    context.success?.should == true

    comment1 = post.comments[0]
    comment1.errors.empty?.should == true

    comment2 = post.comments[1]
    comment2.errors.empty?.should == true

    comment3 = post.comments[2]
    comment3.respond_to?(:errors)

    comment4 = post.comments[3]
    comment3.respond_to?(:errors)

    comment5 = post.comments[4]
    comment3.respond_to?(:errors)

  end

  it "#validates_uniqueness_of with a custom scope and custom conditions" do

    post = RubyPostWithComments.new([{ title: 'title1', email: 'teste1@gmail.com', post_id: 1 }, { title: 'title1', email: 'teste1@gmail.com', post_id: 2 }, { title: 'title2', email: 'teste2@gmail.com', post_id: 1 }, { title: 'title2', email: 'teste2@gmail.com', post_id: 2 }, { title: 'title2', email: 'teste2@gmail.com', post_id: 1 }])
    context = ValidateUniqComments::CustomScopeAndConditions.perform(post: post)

    context.success?.should == false

    comment1 = post.comments[0]
    comment1.errors.empty?.should == true

    comment2 = post.comments[1]
    comment2.errors.empty?.should == true

    comment3 = post.comments[2]
    comment3.errors.added?(:title, :taken).should == true
    comment3.errors.size.should == 1

    comment4 = post.comments[3]
    comment4.errors.empty?.should == true

    comment5 = post.comments[4]
    comment5.errors.added?(:title, :taken).should == true
    comment5.errors.size.should == 1

  end

end
