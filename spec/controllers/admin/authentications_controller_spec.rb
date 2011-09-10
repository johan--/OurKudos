require 'spec_helper'

describe Admin::AuthenticationsController do

  before(:all) do 
    Settings.seed!
  end

  before(:each) do 
    @admin = Factory(:admin_user)
    sign_in @admin
  end

  describe "creating a valid authentication" do
    before(:each) do 
      @user = mock_model(User)
      User.stub!(:find).with('1').and_return(@user)
      @authentication = mock_model(Authentication)
      @user.stub_chain(:authentications, :new).and_return(@authentication)
    end

    def valid_create
      post :create, :user_id => '1', :authentication => {}
    end

    it "should render new and assign new page" do 
      get :new, :user_id => '1'
      response.should be_success
      response.should render_template('new')
    end

    it "should create authentication" do
      @authentication.should_receive(:save).and_return(true)
      valid_create
    end


    it "should redirect" do 
      @authentication.should_receive(:save).and_return(true)
      valid_create
      response.should be_redirect
    end

    it "should redirect to the index path" do 
      @authentication.should_receive(:save).and_return(true)
      valid_create
      response.should redirect_to(admin_user_url(@user))
    end
  end

  describe "creating an invalid page" do
    before(:each) do 
      @user = mock_model(User)
      User.stub!(:find).with('1').and_return(@user)
      @authentication = mock_model(Authentication)
      @user.stub_chain(:authentications, :new).and_return(@authentication)
    end

    def invalid_create
      post :create, :user_id => '1', :authentication => { }
    end

    it "should save the authentication" do 
      @authentication.should_receive(:save).and_return(false)
      invalid_create
    end

    it "should be success" do
      @authentication.should_receive(:save).and_return(false)
      invalid_create
      response.should be_success
    end
    
    it "should re-render the new form" do
      @authentication.should_receive(:save).and_return(false)
      invalid_create
      response.should render_template("new")
    end
  end

  describe "editing a page with valid params" do
    before(:each) do 
      @user = mock_model(User)
      User.stub!(:find).with('1').and_return(@user)
      @authentication = mock_model(Authentication, :update_attributes => true)
      Authentication.stub!(:find).with("1").and_return(@authentication)
    end

    it "assigns the requested authentication as @authentcation" do
      @authentication.stub(:find).with("1") {@authentication}
      get :edit, :id => "1", :user_id => '1'
      assigns(:authentication).should be(@authentication)
    end

    it "assigns the submit url" do
      @authentication.stub(:find).with("1") {@authentication}
      get :edit, :id => "1", :user_id => '1'
      assigns(:submit_url).should eq(admin_user_authentication_path(@user, @authentication))
    end

    it "should find authentication and return object" do 
      Authentication.should_receive(:find).with("1").and_return(@authentication)
      put :update, :id => "1", :user_id => 1, :authentication => {}
    end

    it "should update the authentication objects attributes" do
      @authentication.should_receive(:update_attributes).and_return(true)
      put :update, :id => "1", :user_id => 1, :authentication => {}
    end

    it "should have a flash notice" do
      put :update, :id => "1", :user_id => 1, :authentication => {}
      flash[:notice].should_not be_blank
    end

    it "should have a successful flash notice" do
      put :update, :id => "1", :user_id => 1, :authentication => {}
      flash[:notice].should eql 'Authentication has been updated'
    end

    it "should redirect to the admin page for the userj" do
      put :update, :id => "1", :user_id => 1, :authentication => {}
      response.should redirect_to(admin_user_url(@user, @authentication))
    end
  end

  describe "updating a page with invalid params" do
    before(:each) do 
      @user = mock_model(User)
      User.stub!(:find).with('1').and_return(@user)
      @authentication = mock_model(Authentication, :update_attributes => false)
      Authentication.stub!(:find).with("1").and_return(@authentication)
    end

    it "should find authentication and return object" do
      Authentication.should_receive(:find).with("1").and_return(@authentication)
      put :update, :id => "1", :user_id => 1, :authentication => {}
    end

    it "should update the page objects attributes" do
      @authentication.should_receive(:update_attributes).and_return(false)
      put :update, :id => "1", :user_id => 1, :authentication => {}
    end

    it "should render the edit form" do
      put :update, :id => "1", :user_id => 1, :authentication => {}
      response.should render_template('edit')
    end
  end

  describe "deleting an authentication" do
    before(:each) do 
      @user = mock_model(User)
      User.stub!(:find).with('1').and_return(@user)
      @authentication = mock_model(Authentication, :update_attributes => false)
      Authentication.stub!(:find).with("1").and_return(@authentication)
    end
    it "should destroy the requested authentication" do
      Authentication.should_receive(:find).with("1").and_return(@authentication)
      @authentication.should_receive(:destroy)
      delete :destroy, :id => "1", :user_id => 1 
    end

    it "should redirect on success" do
      Authentication.should_receive(:find).with("1").and_return(@authentication)
      delete :destroy, :id => "1", :user_id => 1 
      response.should redirect_to(admin_user_url(@user))
    end

    it "should set flash[:notice] on success" do
      Authentication.should_receive(:find).with("1").and_return(@authentication)
      delete :destroy, :id => "1", :user_id => 1 
      flash[:notice].should eql 'Authentication has been removed'
    end

    it "should redirect on failure" do
      Authentication.stub!(:find).and_return(@authentication = mock_model(Authentication, :destroy => false))
      delete :destroy, :id => "1", :user_id => 1 
      response.should redirect_to(admin_user_url(@user))
    end

    it "should set flash[:notice] on failure" do
      Authentication.stub!(:find).and_return(@authentication = mock_model(Authentication, :destroy => false))
      delete :destroy, :id => "1", :user_id => 1 
      flash[:notice].should eql 'Unable to remove authentication'
    end

  end
end
