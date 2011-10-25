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

    it 'should set up a new instance on new' do
      get :new
      response.should be_success
      assigns[:kudo].new_record?.should be_true
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

  describe 'creating a kudo' do
    before(:each) do 
      @user = Factory(:user)
      sign_in @user
      @valid_params = Factory.attributes_for(:kudo)
    end

    it 'should create a new kudo on create' do
      lambda{
        post :create, :kudo => @valid_params, :format => :html
      }.should change(Kudo, :count).by(1)
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

    it 'should delete a kudo on destroy' do
      @copy = Factory(:kudo_copy_system, :id => 1, :recipient_id => @user.id)
      subject.current_user.received_kudos.stub!(:find).with('1').and_return(@copy)
      delete :destroy, :id => '1', :user_id => @user.id
      response.should be_redirect
      flash[:notice].should eq("Kudo has been successfully removed from your inbox")
    end
  end

  describe 'hiding a kudo' do
    before(:each) do 
      @user = Factory(:user)
      sign_in @user
      @user2 = Factory(:user)
      @kudo = Factory(:kudo, :to => "#{@user.primary_identity.id}, #{@user2.primary_identity.id}")
    end

    it 'should hide the kudo for the current user' do
      subject.current_user.newsfeed_kudos.stub!(:find).with('1').and_return(@kudo)
      post :hide, :id => '1', :user_id => @user.id
      response.should be_redirect
      flash[:notice].should eq("Kudo has been successfully removed")

    end

    it 'should redirect home when hide fails' do
     #stub hide for with failure 
      subject.current_user.newsfeed_kudos.stub!(:find).with('1').and_return(@kudo)
      post :hide, :id => '1', :user_id => @user.id
      response.should be_redirect
      flash[:notice].should eq("Kudo has been successfully removed")

    end
    
  end

end
