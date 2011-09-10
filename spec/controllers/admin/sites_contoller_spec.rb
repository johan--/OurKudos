require 'spec_helper'

describe Admin::SitesController do

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
    assigns(:sites).should_not be_nil
  end

  describe "creating a valid page" do
    before(:each) do 
      @valid_params = Factory.attributes_for(:site)
    end

    def valid_create
      post :create, :site => @valid_params
    end

    it "should render new and assign new site" do 
      get 'new'
      assigns(:site).class.should == Site
      assigns(:site).new_record?.should be(true)
      response.should be_success
      response.should render_template('new')
    end

    it "should create site" do
      lambda {
        post :create, :site => @valid_params
      }.should change(Site, :count).by(1)
    end

    it "should save the site" do 
      Site.stub!(:new).and_return(@site = mock_model(Site, :save => true))
      @site.should_receive(:save).and_return(true)
      valid_create
    end

    it "should redirect" do 
      valid_create
      response.should be_redirect
    end

    it "should assign site" do
      Site.stub!(:new).and_return(@site = mock_model(Site, :save => true))
      valid_create
      assigns(:site).should == @site
    end

    it "should redirect to the index path" do 
      Site.stub!(:new).and_return(@site = mock_model(Site, :save => true))
      valid_create
      response.should redirect_to(admin_sites_url)
    end
  end

  describe "creating an invalid site" do
    before(:each) do 
      Site.stub!(:new).and_return(@site = mock_model(Site, :save => false))
      @invalid_params = {}
    end

    def invalid_create
      post :create, :site => { }
    end

    it "should not create site" do
      lambda {
        post :create, :site => @invalid_params
      }.should_not change(Site, :count)
    end

    it "should not save the site" do 
      @site.should_receive(:save).and_return(false)
      invalid_create
    end

    it "should be success" do
      invalid_create
      response.should be_success
    end
    
    it "should assign site" do
      invalid_create
      assigns(:site).should == @site
    end

    it "should re-render the new form" do
      invalid_create
      response.should render_template("new")
    end
  end

  describe "editing a site with valid params" do
    before(:each) do 
      @site = mock_model(Site, :update_attributes => true)
      keys = mock_model(ApiKey)
      Site.stub!(:find).with("1").and_return(@site)
      @site.stub_chain(:api_keys, :order).and_return(keys)
    end

    it "assigns the requested site as @site" do
      Site.stub(:find).with("1") {@site}
      get :show, :id => "1"
      assigns(:site).should be(@site)
    end

    it "should find site and return object" do 
      Site.should_receive(:find).with("1").and_return(@site)
      put :update, :id => "1", :site => {}
    end

    it "should update the site objects attributes" do
      @site.should_receive(:update_attributes).and_return(true)
      put :update, :id => "1", :site => {}
    end

    it "should have a flash notice" do
      put :update, :id => "1", :site => {}
      flash[:notice].should_not be_blank
    end

    it "should have a successful flash notice" do
      put :update, :id => "1", :site => {}
      flash[:notice].should eql 'Site has been updated'
    end

    it "should redirect to site index site" do
      put :update, :id => "1", :site => {}
      response.should redirect_to(admin_site_url(@site))
    end
  end

  describe "updating a site with invalid params" do
    before(:each) do 
      @site = mock_model(Site, :update_attributes => false)
      keys = mock_model(ApiKey)
      Site.stub!(:find).with("1").and_return(@site)
      @site.stub_chain(:api_keys, :order).and_return(keys)
    end

    it "should find site and return object" do
      Site.should_receive(:find).with("1").and_return(@site)
      put :update, :id => "1", :site => {}
    end

    it "should not update the site objects attributes" do
      @site.should_receive(:update_attributes).and_return(false)
      put :update, :id => "1", :site => {}
    end

    it "should render the show page" do
      put :update, :id => "1", :site => {}
      response.should render_template('show')
    end
  end

  describe "deleting a site" do
    before(:each) do 
      @site = mock_model(Site)
      Site.stub!(:find).with("1").and_return(@site)
      @site.stub_chain(:api_keys, :destroy_all).and_return(true)
    end

    it "should destroy the requested site" do
      Site.should_receive(:find).with("1").and_return(@site)
      @site.should_receive(:destroy)
      delete :destroy, :id => "1"
    end

    it "should redirect on success" do
      Site.should_receive(:find).with("1").and_return(@site)
      delete :destroy, :id => "1"
      response.should redirect_to(admin_sites_url)
    end

    it "should set flash[:notice] on success" do
      Site.should_receive(:find).with("1").and_return(@site)
      delete :destroy, :id => "1"
      flash[:notice].should eql 'Site has been removed'
    end

    it "should redirect on site destroy failure" do
      Site.stub!(:find).and_return(@site = mock_model(Site, :destroy => false))
      @site.stub_chain(:api_keys, :destroy_all).and_return(true)
      delete :destroy, :id => "1"
      response.should redirect_to(admin_sites_url)
    end

    it "should redirect on api keys destroy_all failure" do
      Site.stub!(:find).and_return(@site = mock_model(Site, :destroy => true))
      @site.stub_chain(:api_keys, :destroy_all).and_return(false)
      delete :destroy, :id => "1"
      response.should redirect_to(admin_sites_url)
    end

    it "should set flash[:notice] on failure" do
      Site.stub!(:find).and_return(@site = mock_model(Site, :destroy => false))
      @site.stub_chain(:api_keys, :destroy_all).and_return(true)
      delete :destroy, :id => "1"
      flash[:notice].should eql 'Unable to remove this site'
    end

  end

  describe "banning sites" do
    before(:each) do 
      @site1 = Factory(:site, :blocked => true)
      @site2 = Factory(:site, :blocked => false)
    end

    it "should mark selected sites as not banned" do
      valid_params = {"#{@site1.id}" => 'false'}
      Site.stub!(:find).and_return(site = mock_model(Site))
      site.should_receive(:unban!).and_return(true)
      post :ban, :sites => valid_params
      response.should redirect_to(admin_sites_path) 
    end

    it "should mark selected sites as banned" do
      Site.stub!(:find).and_return(site = mock_model(Site))
      valid_params = {"#{site.id}" => 'true'}
      site.should_receive(:ban!).and_return(true)
      post :ban, :sites => valid_params
      response.should redirect_to(admin_sites_path) 
    end

    it "should set flash[:notice] on success" do
      Site.stub!(:find).and_return(site = mock_model(Site))
      valid_params = {"#{site.id}" => 'true'}
      site.should_receive(:ban!).and_return(true)
      post :ban, :sites => valid_params
      flash[:notice].should eql 'Selected sites were updated'
    end

  end

end
