require 'spec_helper'

describe KudoCopy do

  before(:all) do
    Settings.seed!
  end

  describe "instance" do
    before(:each) do 
      @user = Factory(:user, :first_name => "Steve", :last_name => "Jobs")
      @user.primary_identity.update_attribute('display_identity', true)
    end

    it 'should know about its recipient name' do
      @kudo_copy = Factory(:kudo_copy_system, :recipient => @user)

      @kudo_copy.should respond_to "copy_recipient"
      @kudo_copy.copy_recipient.should eq("Steve J.")
      @kudo_copy.recipient eq(@user)
    end

  end


end
