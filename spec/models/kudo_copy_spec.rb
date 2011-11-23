require 'spec_helper'

describe KudoCopy do

  before(:all) do
    Settings.seed!
  end

  describe "instance" do
    before(:each) do 
      @user = Factory(:user,  :first_name => 'Steve',
                              :last_name => 'Jobs')
      @user.primary_identity.update_attribute('display_identity', true)
    end

    it 'should know about its recipient name' do
      @kudo_copy = Factory(:kudo_copy_system, :recipient => @user)

      kudo = Factory(:kudo, :to => @user.identities.first.id.to_s)
      @kudo_copy = kudo.kudo_copies.first

      @kudo_copy.should respond_to "copy_recipient"
      @kudo_copy.copy_recipient.should == 'Steve J.'
    end

  end


end
