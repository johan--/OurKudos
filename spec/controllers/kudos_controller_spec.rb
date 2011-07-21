require 'spec_helper'

describe KudosController do

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

end
