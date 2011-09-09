require 'spec_helper'

describe Admin::ForbiddenPasswordsController do

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
    assigns(:forbidden_passwords).should_not be_nil
    assigns(:forbidden_password).class.should eq(ForbiddenPassword)
    assigns(:forbidden_password).new_record?.should be(true)
  end

  describe "creating a valid forbidden password" do
    before(:each) do 
      @valid_params = Factory.attributes_for(:forbidden_password)
    end

    def valid_create
      post :create, :forbidden_password => @valid_params
    end

    it "should create forbidden password" do
      lambda {
        post :create, :forbidden_password => @valid_params
      }.should change(ForbiddenPassword, :count).by(1)
    end

    it "should save the forbidden password" do 
      ForbiddenPassword.stub!(:new).and_return(@forbidden_password = mock_model(ForbiddenPassword, :save => true))
      @forbidden_password.should_receive(:save).and_return(true)
      valid_create
    end

    it "should redirect" do 
      valid_create
      response.should be_redirect
    end

    it "should redirect to the index path" do 
      ForbiddenPassword.stub!(:new).and_return(@forbidden_password = mock_model(ForbiddenPassword, :save => true))
      valid_create
      response.should redirect_to(admin_forbidden_passwords_url)
    end
  end

  describe "creating an invalid forbidden password" do
    before(:each) do 
      ForbiddenPassword.stub!(:new).and_return(@forbidden_password = mock_model(ForbiddenPassword, :save => false))
      @invalid_params = {}
    end

    def invalid_create
      post :create, :forbidden_password => { }
    end

    it "should create forbidden password" do
      lambda {
        post :create, :forbidden_password => @invalid_params
      }.should_not change(ForbiddenPassword, :count)
    end

    it "should save the forbidden password" do 
      @forbidden_password.should_receive(:save).and_return(false)
      invalid_create
    end

    it "should be success" do
      invalid_create
      response.should be_success
    end
    
    it "should assign forbidden password" do
      invalid_create
      assigns(:forbidden_password).should == @forbidden_password
    end

    it "should re-render the index" do
      invalid_create
      response.should render_template("index")
    end
  end

  describe "deleting a forbidden password" do
    before(:each) do 
      @forbidden_password = mock_model(ForbiddenPassword)
      ForbiddenPassword.stub!(:find).with("1").and_return(@forbidden_password)
    end
    it "should destroy the requested page" do
      ForbiddenPassword.should_receive(:find).with("1").and_return(@forbidden_password)
      @forbidden_password.should_receive(:destroy)
      delete :destroy, :id => "1"
    end

    it "should redirect on success" do
      ForbiddenPassword.should_receive(:find).with("1").and_return(@forbidden_password)
      delete :destroy, :id => "1"
      response.should redirect_to(admin_forbidden_passwords_url)
    end

  end

end
