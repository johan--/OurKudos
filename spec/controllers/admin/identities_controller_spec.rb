require 'spec_helper'
#Several tests here can get cleaned up if we can stub the controllers @user.identities.find call

describe Admin::IdentitiesController do

  describe "creating identity" do

    describe 'access control' do

      it "should redirect user without admin role" do
        user = Factory(:user)
        sign_in user
        get 'new', :user_id => user
        user.has_role?(:admin).should be_false
        response.should redirect_to("/home")
      end

      it "should redirect user without admin role" do
        user = Factory(:user)
        admin = Factory(:admin_user)
        sign_in admin
        get 'new', :user_id => user
        admin.has_role?(:admin).should be_true
        response.should be_success
      end

    end

    describe 'creating a new identity' do
      before(:each) do
        @admin = Factory(:admin_user)
        sign_in @admin
        @user = Factory(:user)
        @valid_params = Factory.attributes_for(:identity, :user_id => @user.id)
      end
 
      it 'should create a new identity' do
        lambda {
          post :create, :user_id => @user, :identity => @valid_params
        }.should change(Identity, :count).by(1)
      end


      it "should redirect to index after successful create" do
        post :create, :user_id => @user, :identity => @valid_params
        response.should be_redirect
      end

    end

    describe "creating an invalid identity" do
      before(:each) do 
        @admin = Factory(:admin_user)
        sign_in @admin
        @user = Factory(:user)
        Identity.stub!(:new).and_return(@identity = mock_model(Identity, :save => false))
        @invalid_params = { :name => ""}
      end

      def invalid_create
        post :create, :user_id => @user, :identity => { :name => ""}
      end

      it "should create identity" do
        lambda {
          post :create, :user_id => @user, :identity => @invalid_params
        }.should_not change(Identity, :count)
      end

      it "should not save the identity" do 
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

    describe "editing identity with valid params" do
      before(:each) do 
        @admin = Factory(:admin_user)
        sign_in @admin
        @user = Factory(:user)
        User.stub!(:find).with(@user.to_param).and_return(@user)
        @identity = Factory(:identity, :id => 1, :user => @user)
        @valid_params = {:identity => "not@real.com", :identity_type => "email"}
      end

      it "should update the identity objects attributes" do
        put :update, :id => '1', :user_id => @user, :identity => @valid_params
        assigns[:identity].identity.should eq("not@real.com")
      end

      it "should redirect to the users admin page" do
        put :update, :id => "1", :user_id => @user, :identity => @valid_params
        response.should redirect_to(admin_user_url(@user))
      end

    end

    describe "updating a identity with invalid params" do
      before(:each) do 
        @admin = Factory(:admin_user)
        sign_in @admin
        @user = Factory(:user)
        User.stub!(:find).with(@user.to_param).and_return(@user)
        @identity = Factory(:identity, :id => 1, :user => @user)
        @invalid_params = {:identity => "", :identity_type => "email"}
      end

      it "should not update the identity attributes" do
        put :update, :id => '1', :user_id => @user, :identity => @valid_params
        response.should render_template 'edit'
      end

    end

    describe "deleting an identity" do
      before(:each) do 
        @admin = Factory(:admin_user)
        sign_in @admin
        @user = Factory(:user)
        User.stub!(:find).with(@user.to_param).and_return(@user)
        @identity = Factory(:identity, :id => 1, :user => @user)
      end
      it "should destroy the requested identity" do
        lambda {
          delete :destroy, :id => @identity.id, :user_id => @user
        }.should change(Identity, :count)
      end

      it "should redirect on success" do
        delete :destroy, :id => @identity.id, :user_id => @user
        response.should redirect_to(admin_user_url(@user))
      end

      it "should set flash[:notice] on success" do
        delete :destroy, :id => @identity.id, :user_id => @user
        flash[:notice].should eql 'Account has been removed'
      end

      it "should redirect on failure" do
        identity = @user.primary_identity
        delete :destroy, :id => identity.id, :user_id => @user
        response.should redirect_to(admin_user_url(@user))
      end

      it "should set flash[:notice] on failure" do
        identity = @user.primary_identity
        delete :destroy, :id => identity.id, :user_id => @user
        flash[:notice].should eql "Unable to remove your account, please make sure you haven't tried to remove your primary account"
      end

    end
      
  end
end
