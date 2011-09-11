require 'spec_helper'

describe Admin::UsersController do

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

  it "should render the user roles page" do
    user = mock_model(User)
    User.stub!(:find).with("1").and_return(user)
    get 'roles', :id => '1'
    assigns(:user).should eq(user)
  end

  describe "updating a user" do
    before(:each) do 
      @user = mock_model(User, :skip_password_validation => true)
      User.stub!(:find).with("1").and_return(@user)
      User.should_receive(:find).with("1").and_return(@user)
      @user.stub!(:skip_password_validation=).and_return(true)
      @user.stub_chain(:roles, :delete_all).and_return(true)
      @user.should_receive(:update_attributes).and_return(true)
    end

    it "should redirect to the admin user path" do 
      put :update, :id => "1", :roles => "editor", :user => {}
      response.should redirect_to(admin_users_path)
    end

    it "should have a flash notice" do
      put :update, :id => "1", :roles => "editor", :user => {}
      flash[:notice].should_not be_blank
    end

    it "should have a successful flash notice" do
      put :update, :id => "1", :roles => "editor", :user => {}
      flash[:notice].should eql 'User data updated successfully'
    end

  end

  describe "showing a user" do
    before(:each) do 
      @user = mock_model(User)
      User.stub!(:find).with("1").and_return(@user)
      User.should_receive(:find).with("1").and_return(@user)
      @authentication = mock_model(Authentication)
      @user.stub!(:authentications).and_return(@authentication)
    end

    it "should return the requested user" do
      get :show, :id => '1'
      response.should render_template('show')
      assigns(:user).should eq(@user)
    end

  end

  describe "deleting a user" do
    before(:each) do 
      @user = mock_model(User)
      User.stub!(:find).with("1").and_return(@user)
      User.should_receive(:find).with("1").and_return(@user)
      @authentication = mock_model(Authentication)
      #@authentication.should_receive(:destroy_all).and_return(true)
      @user.stub!(:authentications).and_return(@authentication)
    end

    it "should destroy the requested user" do
      User.should_receive(:find).with("1").and_return(@user)
      @user.stub_chain(:authentications, :destroy_all).and_return(true)
      @user.should_receive(:destroy)
      delete :destroy, :id => "1"
    end

    it "should redirect on success" do
      User.should_receive(:find).with("1").and_return(@user)
      @user.stub_chain(:authentications, :destroy_all).and_return(true)
      delete :destroy, :id => "1"
      response.should redirect_to(admin_users_url)
    end

    it "should set flash[:notice] on success" do
      User.should_receive(:find).with("1").and_return(@site)
      @user.stub_chain(:authentications, :destroy_all).and_return(true)
      delete :destroy, :id => "1"
      flash[:notice].should eql 'There was problem removing this user'
    end

    it "should redirect on user destroy failure" do
      User.stub!(:find).and_return(@user = mock_model(User, :destroy => false))
      @user.stub_chain(:authentications, :destroy_all).and_return(true)
      delete :destroy, :id => "1"
      response.should redirect_to(admin_users_url)
      flash[:notice].should eql 'There was problem removing this user'
    end

    it "should redirect on user authentications destroy_all failure" do
      User.stub!(:find).and_return(@user = mock_model(User, :destroy => true))
      @user.stub_chain(:authentications, :destroy_all).and_return(false)
      delete :destroy, :id => "1"
      response.should redirect_to(admin_users_url)
      flash[:notice].should eql 'There was problem removing this user'
    end

  end

end
