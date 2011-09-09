require 'spec_helper'

describe Admin::AdminController do

  describe "Permission Redirecting" do

    it "should redirect to root url when no user" do
      get :index
      response.should be_redirect
    end

    it "should get index page if current user is admin" do
      @admin = Factory(:admin_user)
      sign_in @admin
      @admin.has_role?(:admin).should be(true)
      get 'index'
      response.should be_success
      response.should_not be_redirect
    end

    it "should get index page if current user is editor" do
      Role.create([{:name => 'editor'}])
      @user = Factory(:user)
      @user.roles << Role.find_by_name("editor")
      @user.save :validate => false
      sign_in @user
      @user.has_role?('editor').should be(true)
      get 'index'
      response.should be_success
      response.should_not be_redirect
    end

    it "should get index page if current user is gift editor" do
      Role.create([{:name => "gift editor"}])
      @user = Factory(:user)
      @user.roles << Role.find_by_name("gift editor")
      @user.save :validate => false
      sign_in @user
      @user.has_role?('gift editor').should be(true)
      get 'index'
      response.should be_success
      response.should_not be_redirect
    end

  end

end
