require 'spec_helper'

describe KudoCopy do

  before(:all) do
    Settings.seed!
  end

  describe "instance" do
    before(:each) do 
      @user = Factory(:user)
      @user.primary_identity.update_attribute('display_identity', true)
    end

    it 'should know about its recipient name' do
      @kudo_copy = Factory(:kudo_copy_system)

      @kudo_copy.should respond_to "copy_recipient"
      @kudo_copy.copy_recipient.should == @user.secured_name
      @kudo_copy.recipient = kudo_copy.author
      @kudo_copy.copy_recipient.should be_nil
    end

  end


end
