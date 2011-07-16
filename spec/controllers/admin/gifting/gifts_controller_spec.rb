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

  describe "Showing the gift admin page" do
    before(:each) do 
      @gift = mock_model(Gift)
      Gift.stub!(:find).with("1").and_return(@gift)
    end

    it "assigns the requested gift as @gift" do
      Gift.stub(:find).with("1") {@gift}
      get :show, :id => "1"
      assigns(:gift).should be(@gift)
    end

  end
    

    it "assigns the requested gift as @gift" do
      Gift.stub(:find).with("1") {@gift}
      get :edit, :id => "1"
      assigns(:gift).should be(@gift)
    end

  describe "editing a gift with valid params" do
    before(:each) do 
      @gift = mock_model(Gift, :update_attributes => true)
      Gift.stub!(:find).with("1").and_return(@gift)
    end
    

    it "assigns the requested gift as @gift" do
      Gift.stub(:find).with("1") {@gift}
      get :edit, :id => "1"
      assigns(:gift).should be(@gift)
    end

    it "should find gift and return object" do 
      Gift.should_receive(:find).with("1").and_return(@gift)
      put :update, :id => "1", :gift => {}
    end

    it "should update the gift objects attributes" do
      @gift.should_receive(:update_attributes).and_return(true)
      put :update, :id => "1", :gift => {}
    end

    it "should have a flash notice" do
      put :update, :id => "1", :gift => {}
      flash[:notice].should_not be_blank
    end

    it "should have a successful flash notice" do
      put :update, :id => "1", :gift => {}
      flash[:notice].should eql 'Successfully updated gift'
    end

    it "should redirect to the gift's show page" do
      put :update, :id => "1", :gift => {}
      response.should redirect_to(admin_gifting_gift_url(@gift))
    end
  end

  describe "updating a gift with invalid params" do
    before(:each) do 
      @gift = mock_model(Gift, :update_attributes => false)
      Gift.stub!(:find).with("1").and_return(@gift)
    end

    it "should find gift and return object" do
      Gift.should_receive(:find).with("1").and_return(@gift)
      put :update, :id => "1", :gift => {}
    end

    it "should update the gift objects attributes" do
      @gift.should_receive(:update_attributes).and_return(false)
      put :update, :id => "1", :gift => {}
    end

    it "should render the edit form " do
      put :update, :id => "1", :gift => {}
      response.should render_template('edit')
    end
  end

  describe "deleting a gift" do
    before(:each) do 
      @gift = mock_model(Gift)
      Gift.stub!(:find).with("1").and_return(@gift)
    end
    it "should destroy the requested gift" do
      Gift.should_receive(:find).with("1").and_return(@gift)
      @gift.should_receive(:destroy)
      delete :destroy, :id => "1"
    end

    it "should redirect on success" do
      Gift.should_receive(:find).with("1").and_return(@gift)
      delete :destroy, :id => "1"
      response.should redirect_to(admin_gifting_gifts_url)
    end

    it "should set flash[:notice] on success" do
      Gift.should_receive(:find).with("1").and_return(@gift)
      delete :destroy, :id => "1"
      flash[:notice].should eql 'Gift has been deleted'
    end

    it "should redirect on failure" do
      Gift.stub!(:find).and_return(@gift = mock_model(Gift, :destroy => false))
      delete :destroy, :id => "1"
      response.should redirect_to(admin_gifting_gifts_url)
    end

    it "should set flash[:notice] on success" do
      Gift.stub!(:find).and_return(@gift = mock_model(Gift, :destroy => false))
      delete :destroy, :id => "1"
      flash[:notice].should eql 'Gift has not been deleted'
    end

  end

  describe "commission junction update" do
    before(:each) do 
      @gift = mock_model(Gift)
      @gift.stub!(:name, "Testname")
      Gift.stub!(:find).with("1").and_return(@gift)
    end

    it "should redirect on success" do
      @gift.should_receive(:update_commission_junction).and_return(true)
      get :commission_junction_update, :id => "1" 
      response.should be_redirect
    end

    it "should set the flash[:notice on success" do
      @gift.should_receive(:update_commission_junction).and_return(true)
      get :commission_junction_update, :id => "1" 
      flash[:notice].should_not be_blank
    end

    it "should render form on failure" do
      @gift.should_receive(:update_commission_junction).and_return(false)
      get :commission_junction_update, :id => "1" 
      response.should render_template('edit')
    end

    it "should set flash[:error} on failure" do
      @gift.should_receive(:update_commission_junction).and_return(false)
      get :commission_junction_update, :id => "1" 
      flash[:error].should eql "Updated Failed, please update manually"
    end

  end

end
