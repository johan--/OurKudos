require 'spec_helper'

describe Admin::VirtualUsersController do

  before(:all) do 
    Settings.seed!
  end

  before(:each) do 
    @admin = Factory(:admin_user)
    sign_in @admin
  end

  it "should render index" do
    get 'index'
    response.should render_template('index')
    assigns(:users).should_not be_nil
  end

  describe "updating a virtual user" do
    before(:each) do 
      @user = mock_model(VirtualUser)
      VirtualUser.stub!(:find).with("1").and_return(@user)
      VirtualUser.should_receive(:find).with("1").and_return(@user)
    end

    it 'should render edit page' do
      get :edit, :id => "1"
      response.should be_success
    end

    it "should redirect to the admin user path" do 
      @user.should_receive(:update_attributes).and_return(true)
      put :update, :id => "1", :virtual_user => {}
      response.should redirect_to(admin_virtual_users_path)
    end

    it "should have a flash notice" do
      @user.should_receive(:update_attributes).and_return(true)
      put :update, :id => "1", :virtual_user => {}
      flash[:notice].should_not be_blank
    end

    it "should have a successful flash notice" do
      @user.should_receive(:update_attributes).and_return(true)
      put :update, :id => "1", :virtual_user => {}
      flash[:notice].should eql 'Virtual User updated'
    end

  end

  describe "showing a virtual user" do
    before(:each) do 
      @user = mock_model(VirtualUser)
      VirtualUser.stub!(:find).with("1").and_return(@user)
      VirtualUser.should_receive(:find).with("1").and_return(@user)
    end

    it "should return the requested virtual user" do
      get :show, :id => '1'
      response.should render_template('show')
      assigns(:user).should eq(@user)
    end

  end

  describe "deleting a virtual user" do
    before(:each) do 
      @user = mock_model(VirtualUser)
      VirtualUser.stub!(:find).with("1").and_return(@user)
      VirtualUser.should_receive(:find).with("1").and_return(@user)
    end

    it "should destroy the requested user" do
      VirtualUser.should_receive(:find).with("1").and_return(@user)
      @user.should_receive(:destroy)
      delete :destroy, :id => "1"
    end

    it "should redirect on success" do
      VirtualUser.should_receive(:find).with("1").and_return(@user)
      delete :destroy, :id => "1"
      response.should redirect_to(admin_virtual_users_url)
    end

    it "should set flash[:notice] on success" do
      VirtualUser.should_receive(:find).with("1").and_return(@user)
      delete :destroy, :id => "1"
      flash[:notice].should eql 'Virtual User removed'
    end

    it "should redirect on user destroy failure" do
      VirtualUser.stub!(:find).and_return(@user = mock_model(VirtualUser, :destroy => false))
      delete :destroy, :id => "1"
      response.should redirect_to(admin_virtual_users_url)
      flash[:notice].should eql 'There was problem removing this virtual user'
    end

  end

end
