require 'spec_helper'

describe ValidateUser do 

  it "'#validates_format_of' on a ruby object" do

    user = RubyUser.new({ email: "teste@gmail.com" })
    context = ValidateUser.perform(user: user)
    user.errors.empty?.should == true
    context.success?.should == true

    user = RubyUser.new({ email: "testegmail.com" })
    context = ValidateUser.perform(user: user)
    user.errors.size.should == 1
    user.errors.empty?.should == false
    context.success?.should == false

  end
  
end

