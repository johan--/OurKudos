require 'spec_helper'

describe ForbiddenPassword do

  it 'should know if given string is on its password list' do
   fp = ForbiddenPassword.create(:password => "SomePasswithDifferentLetters")
   ForbiddenPassword.should respond_to "exists?"
   ForbiddenPassword.exists?(fp.password).should be_true
   fp.destroy
   ForbiddenPassword.exists?(fp.password).should be_false
  end

  context "from the list" do

    let(:forbidden_password) { Factory(:forbidden_password) }

    it 'should be invalid without password' do
      forbidden_password.password = ''
      forbidden_password.valid?.should be_false
    end

    it 'should be invalid for same password' do
      password = forbidden_password.password
      ForbiddenPassword.new(:password => password).valid?.should_not be_true
    end

    it "it should display password always downcased" do
      fp = ForbiddenPassword.new(:password => "SomePasswithDifferentLetters")
      fp.to_s.should == fp.password.downcase
    end
  end



end

