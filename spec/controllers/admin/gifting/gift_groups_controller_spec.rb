require 'spec_helper'

describe Admin::Gifting::GiftGroupsController do

  before(:each) do 
    @admin = Factory(:admin_user)
    sign_in @admin
  end

  describe "the index page" do
    before(:each) do
      @gift_group = Factory(:gift_group)
      get 'index'
    end

    it "should render index template" do
      response.should render_template('index')
    end

    it "should assign all gift groups to @gift_groups" do
      assigns(:gift_groups).should include(@gift_group)
    end

    it "should assign new gift group to @gift_group" do
      assigns(:gift_group).should be_an_instance_of(GiftGroup)
    end

  end

  describe "creating a new gift group" do 
    before(:each) do 
      GiftGroup.stub!(:new).and_return(@gift_group = mock_model(GiftGroup, :save => true))
    end

    def valid_create
      post :create, :gift_group => { :name => "group1"}
    end


    it "should create gift group" do 
      GiftGroup.should_receive(:new).with( 'name' => "group1")
      valid_create
    end

    it "should save the gift group" do 
      @gift_group.should_receive(:save).and_return(true)
      valid_create
    end

    it "should redirect" do 
      valid_create
      response.should be_redirect
    end

    it "should assign gift group" do
      valid_create
      assigns(:gift_group).should == @gift_group
    end

    it "should to the index path " do 
      valid_create
      response.should redirect_to(admin_gifting_gift_groups_url)
    end

  end

  describe "creating an invalid gift group" do
    before(:each) do 
      GiftGroup.stub!(:new).and_return(@gift_group = mock_model(GiftGroup, :save => false))
    end

    def invalid_create
      post :create, :gift_group => { :name => "group1"}
    end

    it "should create the gift group" do
      GiftGroup.should_receive(:new).with( 'name' => "group1")
      invalid_create
    end

    it "should save the gift group" do 
      @gift_group.should_receive(:save).and_return(false)
      invalid_create
    end

    it "should be success" do
      invalid_create
      response.should be_success
    end
    
    it "should assign gift group" do
      invalid_create
      assigns(:gift_group).should == @gift_group
    end

    it "should re-render the index page" do
      invalid_create
      response.should render_template("index")
    end
  end

  describe "deleting a gift group" do
    before(:each) do 
      @gift_group = mock_model(GiftGroup)
      GiftGroup.stub!(:find).with("1").and_return(@gift_group)
    end

    it "should destroy the requested gift group" do
      GiftGroup.should_receive(:find).with("1").and_return(@gift_group)
      @gift_group.should_receive(:destroy)
      delete :destroy, :id => "1"
    end

    it "should redirect on success" do
      GiftGroup.should_receive(:find).with("1").and_return(@gift_group)
      delete :destroy, :id => "1"
      response.should redirect_to(admin_gifting_gift_groups_url)
    end

    it "should set flash[:notice] on success" do
      GiftGroup.should_receive(:find).with("1").and_return(@gift_group)
      delete :destroy, :id => "1"
      flash[:notice].should eql 'Gift Group has been deleted'
    end

    it "should redirect on failure" do
      GiftGroup.stub!(:find).and_return(@gift_group = mock_model(GiftGroup, :destroy => false))
      delete :destroy, :id => "1"
      response.should redirect_to(admin_gifting_gift_groups_url)
    end

    it "should set flash[:error] on failure" do
      GiftGroup.stub!(:find).and_return(@gift_group = mock_model(GiftGroup, :destroy => false))
      delete :destroy, :id => "1"
      flash[:notice].should eql 'Gift Group has not been deleted'
    end

  end
end
