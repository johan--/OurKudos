require 'spec_helper'

describe Admin::Gifting::GiftsController do

  before(:each) do 
    @admin = Factory(:admin_user)
    sign_in @admin
  end

  it "should render index" do
    get 'index'
    response.should render_template('index')
    assigns(:gifts).should_not be_nil
  end

  context "creating a valid gift" do
    before(:each) do 
      Gift.stub!(:new).and_return(@gift = mock_model(Gift, :save => true))
    end

    def valid_create
      post :create, :gift => { :name => "gift1", 
                        :description => "testdescription",
                        :price => 1.00,
                        :link => "link",
                        :active => true,
                        :affiliate_code => "123abc"}
    end

    it "should render new and assign new gift" do 
      get 'new'
      assigns(:gift).class.should == Gift
      response.should be_success
      response.should render_template('new')
    end

    it "should create gift" do 
      Gift.should_receive(:new).with( 'name' => "gift1", 
                                      'description' => "testdescription",
                                      'price' => 1.00,
                                      'link' => "link",
                                      'active' => true,
                                      'affiliate_code' => "123abc")
      valid_create
    end

    it "should save the gift" do 
      @gift.should_receive(:save).and_return(true)
      valid_create
    end

    it "should redirect" do 
      valid_create
      response.should be_redirect
    end

    it "should assign gift" do
      valid_create
      assigns(:gift).should == @gift
    end

    it "should to the index path " do 
      valid_create
      response.should redirect_to(admin_gifting_gift_url(@gift))
    end
  end

  
  context "creating an invalid gift" do
    before(:each) do 
      Gift.stub!(:new).and_return(@gift = mock_model(Gift, :save => false))
    end

    def invalid_create
      post :create, :gift => { :name => "gift1", 
                        :description => "testdescription",
                        :price => 1.00,
                        :link => "link",
                        :active => true,
                        :affiliate_code => "123abc"}
    end

    it "should create the gift" do
      Gift.should_receive(:new).with( 'name' => "gift1", 
                                      'description' => "testdescription",
                                      'price' => 1.00,
                                      'link' => "link",
                                      'active' => true,
                                      'affiliate_code' => "123abc")
      invalid_create
    end

    it "should save the gift" do 
      @gift.should_receive(:save).and_return(false)
      invalid_create
    end

    it "should be success" do
      invalid_create
      response.should be_success
    end
    
    it "should assign gift" do
      invalid_create
      assigns(:gift).should == @gift
    end

    it "should re-render the new form" do
      invalid_create
      response.should render_template("new")
    end
  end

end
