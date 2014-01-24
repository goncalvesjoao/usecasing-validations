require 'spec_helper'

describe ValidateUniqComments do 

  it "#validates_uniqueness_of on multiple instances of 'RubyComment' inside a 'RubyPost'" do

    post = RubyPostWithComments.new([{ title: 'title1', email: 'teste1@gmail.com' }, { title: 'title1', email: 'teste2@gmail.com' }])
    context = ValidateUniqComments.perform(post: post)

    context.success?.should == false

    comment1 = post.comments[0]
    comment1.errors.added?(:title, :taken).should == true
    comment1.errors.size.should == 1

    comment2 = post.comments[1]
    comment2.errors.added?(:title, :taken).should == true
    comment2.errors.size.should == 1

  end

end

