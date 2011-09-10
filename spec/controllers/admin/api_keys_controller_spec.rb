require 'spec_helper'

describe Admin::ApiKeysController do

  before(:all) do 
    Settings.seed!
  end

  before(:each) do 
    @admin = Factory(:admin_user)
    sign_in @admin
  end

  describe "creating a new key" do
    before(:each) do 
      @site = mock_model(Site)
      Site.stub!(:find).with("1").and_return(@site)
      @site.stub_chain(:api_keys, :create).and_return(true)
      @request.env['HTTP_REFERER'] = admin_site_url(@site)
    end

   # def valid_create
   #   post :create, :page => @valid_params
   # end

    it "should render new and assign new page" do 
      get 'new', :site_id => "1"
      assigns(:site).should be(@site)
      response.should be_redirect
    end

    it "should assign site" do
      get 'new', :site_id => "1"
      assigns(:site).should == @site
    end

  end

  describe "updating an api key" do
    before(:each) do 
      @key = mock_model(ApiKey)
      ApiKey.stub!(:find).with("1").and_return(@key)
      @site = mock_model(Site)
      @request.env['HTTP_REFERER'] = admin_site_url(@site)
    end

    it "should find api key and return object" do 
      ApiKey.should_receive(:find).with("1").and_return(@key)
      put :update, :id => "1", :api_key => {}
    end

    it "should receive subaction regenerate" do
      @key.should_receive(:regenerate!).and_return(true)
      put :update, :id => "1", :subaction => 'regenerate', :api_key => {}
    end

    it "should receive subaction for disabled" do
      @key.should_receive(:set_as_expired!).and_return(true)
      put :update, :id => "1", :subaction => 'disable', :api_key => {}
    end

    it "should receive subaction for enabled" do
      @key.should_receive(:set_as_valid!).and_return(true)
      put :update, :id => "1", :subaction => 'enable', :api_key => {}
    end

    it "should receive subaction for remove" do
      @key.should_receive(:destroy).and_return(true)
      put :update, :id => "1", :subaction => 'remove', :api_key => {}
    end

    it "should have a flash notice" do
      put :update, :id => "1", :api_key => {}
      flash[:notice].should_not be_blank
    end

    it "should have a successful flash notice" do
      put :update, :id => "1", :api_key => {}
      flash[:notice].should eql 'Key has been updated'
    end

  end

end
