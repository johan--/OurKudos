require 'spec_helper'

describe DisplayIdentitiesController do

  before(:each) do 
    @user = Factory(:user)
    sign_in @user
  end

  

  describe "editing an identity with valid params" do
    before(:each) do 
      @identity = mock_model(Identity, 
                             :identifiable_id => @user.id,
                             :identifiable_type => 'User',
                             :identity_type => 'email',
                             :update_attributes => true)
      subject.current_user.identities.stub!(:find).with("1").and_return(@identity)
    end

    it "should have a current_user" do
      subject.current_user.should_not be_nil
    end

    it "assigns the current users identities @identity" do
      get :edit, :id => @user.id
      assigns(:identities).first.identifiable_id.should eq(@identity.identifiable_id)
      assigns(:identities).first.identity_type.should eq(@identity.identity_type)
    end

    it "should have a flash notice" do
      Identity.stub!(:update_display_identity).and_return(true)
      put :update, :id => @user.id, :display_identity => 1
      flash[:notice].should_not be_blank
    end

    it "should have a successful flash notice" do
      Identity.stub!(:update_display_identity).and_return(true)
      put :update, :id => @user.id, :display_identity => 1
      flash[:notice].should eq('Display Account Updated!')
    end

    it "should redirect to the identities show page" do
      Identity.stub!(:update_display_identity).and_return(true)
      put :update, :id => @user.id, :display_identity => 1
      response.should redirect_to(user_url(@user))
    end
  end

  describe "updating a identity with invalid params" do
    before(:each) do 
      @identity = mock_model(Identity, :user_id => @user.id, :update_attributes => true)
      subject.current_user.identities.stub!(:find).with("1").and_return(@identity)
    end

    it "should have a flash notice" do
      Identity.stub!(:update_display_identity).and_return(false)
      put :update, :id => @user.id, :display_identity => 1
      flash[:error].should_not be_blank
    end

    it "should have a successful flash notice" do
      Identity.stub!(:update_display_identity).and_return(false)
      put :update, :id => @user.id, :display_identity => 1
      flash[:error].should eql('There was a problem please try again')
    end

    it "should redirect to the identities show page" do
      Identity.stub!(:update_display_identity).and_return(false)
      put :update, :id => @user.id, :display_identity => 1
      response.should redirect_to(edit_display_identity_url(@user))
    end
  end

end
