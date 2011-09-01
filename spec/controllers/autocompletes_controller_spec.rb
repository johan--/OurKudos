require 'spec_helper'

describe AutocompletesController do
  before(:all) do
    Settings.seed!
  end

  describe "Exact recipients" do
    before(:each) do 
      @other_user = Factory(:user) 
      identity = Identity.new(:user_id => @other_user.id,
                              :identity => "itweet", 
                              :identity_type => "twitter")
      identity.save(:validate => false)
      @user = Factory(:user)
      sign_in @user
    end

    it "should return only one recipient" do
      get 'new', :object => 'exact', :q => 'itweet'
      assigns[:items].size.should be(1)
    end

    it "should exact match the query param" do
      identity = 'itweet'
      get 'new', :object => 'exact', :q => identity
      assigns[:items].first['name'].should eq("[#{@other_user.first_name} #{@other_user.last_name}] @#{identity}")
    end

    it "should return 'no matches' if no matches exist" do
      get 'new', :object => 'exact', :q => 'nousers'
      assigns[:items].size.should be(0)
    end

  end

  describe "inline_autocomplete_identities" do
    before(:each) do 
      @other_user = Factory(:user, :first_name => "John", :last_name => "Doe") 
      identity = Identity.new(:user_id => @other_user.id,
                              :identity => "itweet", 
                              :identity_type => "twitter")
      identity.save(:validate => false)
      @user = Factory(:user)
      Factory(:friendship, :user_id => @user.id, :friend_id => @other_user.id)
      sign_in @user
    end

    it 'should return and array of identities' do
      get 'inline_autocomplete_identities'
      assigns[:items].should include(['@itweet', "John D."])
    end

  end

end

