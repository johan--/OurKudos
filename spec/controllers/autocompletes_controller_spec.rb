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

    it "should exact match the query param for a twitter identity" do
      identity = 'itweet'
      get 'new', :object => 'exact', :q => identity
      assigns[:items].first['name'].should eq("[#{@other_user.first_name} #{@other_user.last_name}] @#{identity}")
    end

    it "should exact match the query param for an email identity" do
      identity = Identity.new(:user_id => @other_user.id,
                              :identity => "myemail@notreal.com", 
                              :identity_type => "email")
      identity.save(:validate => false)
      search_term = 'myemail@notreal.com'
      get 'new', :object => 'exact', :q => search_term
      assigns[:items].first['name'].should eq("[#{@other_user.first_name} #{@other_user.last_name}] #{search_term}")
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
      assigns[:items].should include(["John D.", '@itweet'])
    end

  end

end

