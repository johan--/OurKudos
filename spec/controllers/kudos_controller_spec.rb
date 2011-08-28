require 'spec_helper'

describe KudosController do

  before :all do
    Settings.seed!
  end

  describe "Single Kudo View registered member" do
    
    before(:each) do 
      @user = Factory(:user)
      sign_in @user
      @kudo = Factory(:kudo)
    end

    it "should render show page" do
      get 'show', :id => @kudo.id
      response.should be_success
    end

    it "should assign kudo to @kudo " do
      get 'show', :id => @kudo.id
      assigns[:kudo].should == @kudo
    end

    it "should not show kudo if kudo is not public" do
      kudo = Factory(:kudo, :share_scope => 'friends')
      get 'show', :id => kudo.id 
      response.should be_redirect
      flash[:notice].should == "You are not authorized to view this kudo"
    end
    
    it "should not require log in to view public kudo" do
      sign_out @user
      get 'show', :id => @kudo.id
      response.should be_success
    end
  end

  describe "deleting a kudo" do
    before(:each) do 
      @user = Factory(:user)
      sign_in @user
      @kudo = Factory(:kudo, :to => @user.primary_identity.id.to_s)
      @user2 = Factory(:user)
      @kudo2 = Factory(:kudo, :to => "#{@user.primary_identity.id}, #{@user2.primary_identity.id}")
    end

    it "should allow recipient to delete if they are only recipient" do
      delete :destroy_sent, :id => @kudo.id, :user_id => @user.id
      response.should be_redirect
      flash[:notice].should eq("Kudo has been successfully removed")
    end

  end

end
