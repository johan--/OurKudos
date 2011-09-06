require 'spec_helper'

describe IdentitiesController do

  before(:each) do 
    @user = Factory(:user)
    sign_in @user
  end

  describe "creating a valid identity" do
    before(:each) do 
      @valid_params = { :identity => "not@real.com",
                        :identity_type => "email"}

    end

    def valid_create
      post :create, :user_id => @user.id, :identity => @valid_params
    end

    it "should render new and assign new identity" do 
      get :new, :user_id => @user.id
      assigns(:identity).class.should == Identity
      response.should be_success
      response.should render_template('new')
    end

    it "should create identity" do
      lambda {
        post :create, :user_id => @user.id, :identity => @valid_params
      }.should change(Identity, :count).by(1)
    end

    it "should save the identity" do 
      Identity.stub!(:new).and_return(@identity = mock_model(Identity, :save => true))
      @identity.should_receive(:save).and_return(true)
      valid_create
    end

    it "should redirect" do 
      valid_create
      response.should be_redirect
    end

    it "should assign identity" do
      Identity.stub!(:new).and_return(@identity = mock_model(Identity, :save => true))
      valid_create
      assigns(:identity).should == @identity
    end

    it "should redirect to the users path " do 
      Identity.stub!(:new).and_return(@identity = mock_model(Identity, :save => true))
      valid_create
      response.should redirect_to(user_url(@user))
    end
  end

  
  describe "creating an invalid identity" do
    before(:each) do 
      Identity.stub!(:new).and_return(@identity = mock_model(Identity, :save => false))
      @valid_params = { :identity => "",
                        :identity_type => "email"}
    end

    def invalid_create
      post :create, :user_id => @user.id, :identity => {  :identity => "", 
                                :identity => "email"}
    end

    it "should not create identity" do
      lambda {
        post :create, :user_id => @user.id, :identity => @invalid_params
      }.should_not change(Identity, :count)
    end

    it "should save the identity" do 
      @identity.should_receive(:save).and_return(false)
      invalid_create
    end

    it "should be success" do
      invalid_create
      response.should be_success
    end
    
    it "should assign identity" do
      invalid_create
      assigns(:identity).should == @identity
    end

    it "should re-render the new form" do
      invalid_create
      response.should render_template("new")
    end
  end

  describe "editing an identity with valid params" do
    before(:each) do 
      @identity = mock_model(Identity, :user_id => @user.id, :update_attributes => true)
      subject.current_user.identities.stub!(:find).with("1").and_return(@identity)
    end

    it "should have a current_user" do
      subject.current_user.should_not be_nil
    end

    it "assigns the requested identity as @identity" do
      get :edit, :user_id => @user.id, :id => "1"
      assigns(:identity).should eq(@identity)
    end

    it "should find gift and return object" do 
      subject.current_user.identities.should_receive(:find).with('1').and_return(@identity)
      put :update, :id => '1', :user_id => @user.id, :identity => {}
    end

    it "should update the identities objects attributes" do
      @identity.should_receive(:update_attributes).and_return(true)
      put :update, :id => "1", :user_id => @user.id, :identity => {}
    end

    it "should have a flash notice" do
      put :update, :id => "1", :user_id => @user.id, :identity => {}
      flash[:notice].should_not be_blank
    end

    it "should have a successful flash notice" do
      put :update, :id => "1", :user_id => @user.id, :identity => {}
      flash[:notice].should eql('Your account has been successfully updated')
    end

    it "should redirect to the identities show page" do
      put :update, :id => "1", :user_id => @user.id, :identity => {}
      response.should redirect_to(user_url(@user))
    end
  end

  describe "updating a identity with invalid params" do
    before(:each) do 
      @identity = mock_model(Identity, :update_attributes => false)
      subject.current_user.identities.stub!(:find).with("1").and_return(@identity)
    end

    it "should find identity and return object" do
      subject.current_user.identities.should_receive(:find).with("1").and_return(@identity)
      put :update, :id => "1", :user_id => @user.id, :identity => {}
    end

    it "should update the identity objects attributes" do
      @identity.should_receive(:update_attributes).and_return(false)
      put :update, :id => "1", :user_id => @user.id, :identity => {}
    end

    it "should render the edit form " do
      put :update, :id => "1", :user_id => @user.id, :identity => {}
      response.should render_template('edit')
    end
  end

  describe "deleting a identity" do
    before(:each) do 
      @identity = mock_model(Identity)
      subject.current_user.identities.stub!(:find).with("1").and_return(@identity)
    end
    it "should destroy the requested identity" do
      subject.current_user.identities.should_receive(:find).with("1").and_return(@identity)
      @identity.should_receive(:destroy)
      delete :destroy, :user_id => @user.id, :id => "1"
    end

    it "should redirect on success" do
      subject.current_user.identities.should_receive(:find).with("1").and_return(@identity)
      delete :destroy, :user_id => @user.id, :id => "1"
      response.should redirect_to(user_url(@user))
    end

    it "should set flash[:notice] on success" do
      subject.current_user.identities.should_receive(:find).with("1").and_return(@identity)
      delete :destroy, :user_id => @user.id, :id => "1"
      flash[:notice].should eql 'Account has been removed'
    end

    it "should redirect on failure" do
      subject.current_user.identities.stub!(:find).and_return(@identity = mock_model(Identity, :destroy => false))
      delete :destroy, :user_id => @user.id, :id => "1"
      response.should redirect_to(user_url(@user))
    end

    it "should set flash[:notice] on failure" do
      subject.current_user.identities.stub!(:find).and_return(@identity = mock_model(Identity, :destroy => false))
      delete :destroy, :user_id => @user.id, :id => "1"
      flash[:notice].should eql("Unable to remove your account, please make sure you haven't tried to remove your primary account")
    end


    it "should not delete on failure" do
      subject.current_user.identities.stub!(:find).and_return(@identity = mock_model(Identity, :destroy => false))
      lambda {
        delete :destroy, :user_id => @user.id, :id => "1"
      }.should_not change(Identity, :count)
    end
    #removing identity changes count

  end
end
