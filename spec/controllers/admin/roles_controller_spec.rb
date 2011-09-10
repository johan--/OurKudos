require 'spec_helper'

describe Admin::RolesController do

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
    assigns(:roles).should_not be_nil
    assigns(:role).new_record?.should be(true)
  end

  describe "creating a valid role" do
    before(:each) do 
      @valid_params = Factory.attributes_for(:role)
    end

    def valid_create
      post :create, :role => @valid_params
    end

    it "should create role" do
      lambda {
        post :create, :role => @valid_params
      }.should change(Role, :count).by(1)
    end

    it "should save the role" do 
      Role.stub!(:new).and_return(@role = mock_model(Role, :save => true))
      @role.should_receive(:save).and_return(true)
      valid_create
    end

    it "should redirect" do 
      valid_create
      response.should be_redirect
    end

    it "should assign role" do
      Role.stub!(:new).and_return(@role = mock_model(Role, :save => true))
      valid_create
      assigns(:role).should == @role
    end

    it "should redirect to the index path" do 
      Role.stub!(:new).and_return(@role = mock_model(Role, :save => true))
      valid_create
      response.should redirect_to(admin_roles_url)
    end
  end

  describe "creating an invalid page" do
    before(:each) do 
      Role.stub!(:new).and_return(@role = mock_model(Role, :save => false))
      @invalid_params = {}
    end

    def invalid_create
      post :create, :role => { }
    end

    it "should not create role" do
      lambda {
        post :create, :role => @invalid_params
      }.should_not change(Role, :count)
    end

    it "should save the page" do 
      @role.should_receive(:save).and_return(false)
      invalid_create
    end

    it "should be success" do
      invalid_create
      response.should be_success
    end
    
    it "should assign role" do
      invalid_create
      assigns(:role).should == @role
    end

    it "should re-render the index page" do
      invalid_create
      response.should render_template("index")
    end
  end

  describe "deleting a role" do
    before(:each) do 
      @role = mock_model(Role)
      Role.stub!(:find).with("1").and_return(@role)
      @request.env['HTTP_REFERER'] = admin_roles_url
    end

    it "should destroy the requested page" do
      Role.should_receive(:find).with("1").and_return(@role)
      @role.should_receive(:destroy)
      delete :destroy, :id => "1"
    end

    it "should redirect on success" do
      Role.should_receive(:find).with("1").and_return(@role)
      delete :destroy, :id => "1"
      response.should redirect_to(admin_roles_url)
    end

    it "should set flash[:notice] on success" do
      Role.should_receive(:find).with("1").and_return(@role)
      delete :destroy, :id => "1"
      flash[:notice].should eql 'Role has been deleted'
    end

    it "should redirect on failure" do
      Role.stub!(:find).and_return(@role = mock_model(Role, :destroy => false))
      delete :destroy, :id => "1"
      response.should redirect_to(admin_roles_url)
    end

    it "should set flash[:notice] on failure" do
      Role.stub!(:find).and_return(@roles = mock_model(Role, :destroy => false))
      delete :destroy, :id => "1"
      flash[:notice].should eql 'Role has not been deleted'
    end
  end
end
