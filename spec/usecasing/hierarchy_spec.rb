require 'spec_helper'

describe 'Testing hierarchy capabilities' do

  it "HierarchyValidation::Son should be able to inherit Father's validations and alter them" do
    post_for_father = RubyPostWithComments.new([{ title: "title1" }, { email: "fakemail" }])
    post_for_son = post_for_father.dup

    father_context = HierarchyValidation::Father.perform(post: post_for_father)
    father_context.success?.should == false

    post_for_father.errors.added?(:title, :blank).should == true
    post_for_father.errors.size.should == 1

    son_context = HierarchyValidation::Son.perform(post: post_for_son)
    son_context.success?.should == false

    comment1 = post_for_son.comments[0]
    comment1.errors.added?(:email, :blank).should == true
    comment1.errors.size.should == 1

    comment2 = post_for_son.comments[1]
    comment2.errors.added?(:title, :blank).should == true
    comment2.errors.size.should == 1
  end

end

