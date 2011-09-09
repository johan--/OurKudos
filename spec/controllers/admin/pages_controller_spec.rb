require 'spec_helper'

describe Admin::PagesController do

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
    assigns(:pages).should_not be_nil
  end

  describe "creating a valid page" do
    before(:each) do 
      @valid_params = Factory.attributes_for(:page)

    end

    def valid_create
      post :create, :page => @valid_params
    end

    it "should render new and assign new page" do 
      get 'new'
      assigns(:page).class.should == Page
      response.should be_success
      response.should render_template('new')
    end

    it "should create page" do
      lambda {
        post :create, :page => @valid_params
      }.should change(Page, :count).by(1)
    end

    it "should save the page" do 
      Page.stub!(:new).and_return(@page = mock_model(Page, :save => true))
      @page.should_receive(:save).and_return(true)
      valid_create
    end

    it "should redirect" do 
      valid_create
      response.should be_redirect
    end

    it "should assign page" do
      Page.stub!(:new).and_return(@page = mock_model(Page, :save => true))
      valid_create
      assigns(:page).should == @page
    end

    it "should redirect to the index path" do 
      Page.stub!(:new).and_return(@page = mock_model(Page, :save => true))
      valid_create
      response.should redirect_to(admin_pages_url)
    end
  end

  describe "creating an invalid page" do
    before(:each) do 
      Page.stub!(:new).and_return(@page = mock_model(Page, :save => false))
      @invalid_params = {}
    end

    def invalid_create
      post :create, :gift => { }
    end

    it "should create page" do
      lambda {
        post :create, :page => @invalid_params
      }.should_not change(Page, :count)
    end

    it "should save the page" do 
      @page.should_receive(:save).and_return(false)
      invalid_create
    end

    it "should be success" do
      invalid_create
      response.should be_success
    end
    
    it "should assign page" do
      invalid_create
      assigns(:page).should == @page
    end

    it "should re-render the new form" do
      invalid_create
      response.should render_template("new")
    end
  end

  describe "editing a page with valid params" do
    before(:each) do 
      @page = mock_model(Page, :update_attributes => true)
      Page.stub!(:find).with("1").and_return(@page)
    end

    it "assigns the requested page as @page" do
      Page.stub(:find).with("1") {@page}
      get :edit, :id => "1"
      assigns(:page).should be(@page)
    end

    it "should find page and return object" do 
      Page.should_receive(:find).with("1").and_return(@page)
      put :update, :id => "1", :page => {}
    end

    it "should update the page objects attributes" do
      @page.should_receive(:update_attributes).and_return(true)
      put :update, :id => "1", :page => {}
    end

    it "should have a flash notice" do
      put :update, :id => "1", :page => {}
      flash[:notice].should_not be_blank
    end

    it "should have a successful flash notice" do
      put :update, :id => "1", :page => {}
      flash[:notice].should eql 'Page was successfully updated.'
    end

    it "should redirect to page index page" do
      put :update, :id => "1", :page => {}
      response.should redirect_to(admin_pages_url)
    end
  end

  describe "updating a page with invalid params" do
    before(:each) do 
      @page = mock_model(Page, :update_attributes => false)
      Page.stub!(:find).with("1").and_return(@page)
    end

    it "should find page and return object" do
      Page.should_receive(:find).with("1").and_return(@page)
      put :update, :id => "1", :page => {}
    end

    it "should update the page objects attributes" do
      @page.should_receive(:update_attributes).and_return(false)
      put :update, :id => "1", :page => {}
    end

    it "should render the edit form" do
      put :update, :id => "1", :page => {}
      response.should render_template('edit')
    end
  end

  describe "deleting a page" do
    before(:each) do 
      @page = mock_model(Page)
      Page.stub!(:find).with("1").and_return(@page)
    end
    it "should destroy the requested page" do
      Page.should_receive(:find).with("1").and_return(@page)
      @page.should_receive(:destroy)
      delete :destroy, :id => "1"
    end

    it "should redirect on success" do
      Page.should_receive(:find).with("1").and_return(@page)
      delete :destroy, :id => "1"
      response.should redirect_to(admin_pages_url)
    end

  end
end
