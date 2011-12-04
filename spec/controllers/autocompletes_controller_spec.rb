require 'spec_helper'

describe AutocompletesController do
  before(:all) do
    Settings.seed!
  end

  before(:each) do 
    @user = Factory(:user)
    sign_in @user
  end

  describe "Exact recipients" do
    before(:each) do 
      @other_user = User.create(Factory.attributes_for(:user)) 
      identity = Identity.new(:identifiable_id => @other_user,
                              :identity => "itweet", 
                              :identifiable_type => 'User',
                              :identity_type => "twitter")
      identity.save(:validate => false)
    end

    it "should return only one recipient" do
      get 'new', :object => 'exact', :q => 'itweet'
      assigns[:items].size.should be(1)
    end

    it "should exact match the query param for a twitter identity" do
      identity = 'itweet'
      get 'new', :object => 'exact', :q => identity
      assigns[:items].first['name'].should eq("#{@other_user.first_name} #{@other_user.last_name} (Twitter: @#{identity})")
    end

    it "should exact match the query param for an email identity" do
      identity = Identity.new(:identifiable => @other_user,
                              :identity => "myemail@notreal.com", 
                              :identity_type => "email")
      identity.save(:validate => false)
      search_term = 'myemail@notreal.com'
      get 'new', :object => 'exact', :q => search_term
      assigns[:items].first['name'].should eq("#{@other_user.first_name} #{@other_user.last_name} (Email)")
    end


    it "should return 'no matches' if no matches exist" do
      get 'new', :object => 'exact', :q => 'nousers'
      assigns[:items].size.should be(0)
    end

  end

  describe "identities and recipients" do
    before(:each) do 
      @other_user = Factory(:user, 
                            :first_name => "bob",
                            :last_name => "smith") 
      @identity = Identity.new(:identifiable => @other_user,
                              :identity => "itweet", 
                              :identity_type => "twitter")
      @identity.save(:validate => false)
      @identity.confirm!
    end

    it "should return list of identities" do
      get 'new', :object => 'identities', :term => 'bob'
      assigns[:items].should include('itweet')
    end

    it "should return list of recipient" do
      get 'new', :object => 'recipients', :q => 'itweet'
      assigns[:items].first[:name].should include('bob smith (Twitter: @itweet)')
    end
    
    it "should return and empty array for bad parameter" do
      get 'new', :object => '', :q => 'itweet'
      assigns[:items].should be_blank
    end
    
  end

  describe "inline_autocomplete_identities" do
    before(:each) do 
      @other_user = Factory(:user, :first_name => "John", :last_name => "Doe") 
      identity = Identity.new(:identifiable => @other_user,
                              :identity => "itweet", 
                              :identity_type => "twitter")
      identity.save(:validate => false)
      @user = Factory(:user)
      Factory(:friendship, :user_id => @user.id,
              :friendable_id => @other_user.id,
              :friendable_type => 'User')
      sign_in @user
    end

    it 'should return and array of identities' do
      get 'inline_autocomplete_identities'
      assigns[:items].should include(["John Doe", '@itweet'])
    end

    it "should properly set non person identities" do
      identity = Identity.new(:identifiable => @other_user,
                              :identity => "company", 
                              :identity_type => "noperson")
      identity.save(:validate => false)
      get 'inline_autocomplete_identities'
      assigns[:items].should include(["John Doe", 'company'])
    end

  end

end

