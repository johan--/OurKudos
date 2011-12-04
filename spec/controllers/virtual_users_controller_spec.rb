require 'spec_helper'

describe VirtualUsersController do

  before :all do
    Settings.seed!
  end

  before(:each) do 
    @user = Factory(:user)
    sign_in @user
    @virtual_user = Factory(:virtual_user, :first_name => "Walt", :last_name => "Disney")
  end

  describe 'updating a virtual user' do
    it 'should update the virtual user' do
      valid_params = {:first_name => "Steve", :last_name => "Jobs"}
      put :update, :id => @virtual_user.id, :virtual_user => valid_params
      user = VirtualUser.find(@virtual_user.id)
      user.first_name.should eq("Steve")
      user.last_name.should eq("Jobs")
    end
  end

  describe 'update a virtual user to an existing virtual user' do
    before(:each) do
      @new_virtual_user = Factory(:virtual_user, :first_name => "Mickey", :last_name => "Mouse")
      @identity = Identity.new( :identifiable_id => @virtual_user.id,
                                :identifiable_type => "VirtualUser",
                                :identity => "stevejobs",
                                :identity_type => 'twitter')
      @identity.save(:validate => false)
    end

    it 'should change the new identity to the existing virtual identity' do
      valid_params = {:first_name => "Walt", :last_name => "Disney"}
      put :update, :id => @new_virtual_user.id, :virtual_user => valid_params
      Identity.find(@identity.id).identifiable_id.should eq(@virtual_user.id)
    end


  end

  describe 'updating from the form' do
    it 'should update the virtual user' do
      valid_params = {@virtual_user.id.to_s => {:first_name => "Steve", :last_name => "Jobs"}}
      put :update_virtual_users, :virtual_users => valid_params
      user = VirtualUser.find(@virtual_user.id)
      user.first_name.should eq("Steve")
      user.last_name.should eq("Jobs")
    end

  end
  

end
