require 'spec_helper'

describe Admin::SettingsController do

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
    assigns(:social_sharing_enabled).should eq(Settings[:social_sharing_enabled])
    assigns(:sign_up_disabled).should eq(Settings[:sign_up_disabled])
    assigns(:special_message).should eq(Settings[:test_environment_special_message])
  end

  describe "updating a setting" do
    before(:each) do 
      @admin = Factory(:admin_user)
      sign_in @admin
      @setting = mock_model(Settings, :update_attributes => true)
      Settings.stub!(:find).with("1").and_return(@setting)
    end
  
    it "should find setting and return object" do 
      @setting.should_receive(:update_attributes).with("1").and_return(true)
      put :update, :id => '1', :settings => '1'
    end

    it "should update the settings objects attributes" do
      @setting.should_receive(:update_attributes).and_return(true)
      put :update, :id => "1", :settings => {}
    end

    it "should have a flash notice" do
      put :update, :id => "1", :settings => {}
      flash[:notice].should_not be_blank
    end

    it "should have a successful flash notice" do
      put :update, :id => "1", :setting => {}
      flash[:notice].should eql 'Website Options updated.'
    end

    it "should redirect to settings index" do
      put :update, :id => "1", :site => {}
      response.should redirect_to(admin_settings_url)
    end
  end

  describe "updating a setting with invalid params" do
    before(:each) do 
      @admin = Factory(:admin_user)
      sign_in @admin
      @setting = mock_model(Settings, :update_attributes => true)
      Settings.stub!(:find).with("1").and_return(@setting)
    end

    it "should find setting and return object" do
      Settings.should_receive(:find).with("1").and_return(@setting)
      put :update, :id => "1", :settings => {}
    end

    it "should not update the setting objects attributes" do
      @setting.should_receive(:update_attributes).and_return(false)
      put :update, :id => "1", :setting => {}
    end

    it "should redirect to admin settings index page" do
      @setting.should_receive(:update_attributes).and_return(false)
      put :update, :id => "1", :site => {}
      response.should redirect_to(admin_settings_url)
    end

    it "should have a flash notice" do
      @setting.should_receive(:update_attributes).and_return(false)
      put :update, :id => "1", :settings => {}
      flash[:notice].should_not be_blank
    end

    it "should have a successful flash notice" do
      @setting.should_receive(:update_attributes).and_return(false)
      put :update, :id => "1", :setting => {}
      flash[:notice].should eql 'Website Options not updated.'
    end
  end
end
