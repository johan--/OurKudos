require 'spec_helper'

describe VirtualUser do

  before :all do
    Settings.seed!
  end

  describe 'creating a new virtual user' do
    before(:each) do
      @user = Factory(:user)
    end

    it 'should create a new virtual when kudo sent to nonmember' do
      lambda {
        @kudo = Factory(:kudo, :to => "@mickeymouse")
        #puts @kudo.process_virtual_users
      }.should change(VirtualUser, :count).by(1)
    end

    it 'should intially set the first and last name to identity' do
      @kudo = Factory(:kudo, :to => "@mickeymouse")
      virtual_user = VirtualUser.first
      virtual_user.first_name.should eq("@mickeymouse")
      virtual_user.last_name.should eq("@mickeymouse")
    end

    #should update a virtual user when sent them
    #kudo needs to get updated with virtual user id
  end

end

