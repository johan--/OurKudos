require 'spec_helper'

describe Admin::Gifting::MerchantsController do

  before(:each) do 
    @admin = Factory(:admin_user)
    sign_in @admin
  end

  it "should render index" do
    get 'index'
    response.should render_template('index')
    assigns(:merchants).should_not be_nil
  end

  describe "creating a valid merchant" do
    before(:each) do 
      Merchant.stub!(:new).and_return(@merchant = mock_model(Merchant, :save => true))
    end

    def valid_create
      post :create, :merchant => { :name => "merchant1", 
                        :homepage => "www.test.com",
                        :description => "testdescription",
                        :affiliate_program_id => 1,
                        :affiliate_code => "123abc"}
    end

    it "should render new and assign new merchant" do 
      get 'new'
      assigns(:merchant).class.should == Merchant
      response.should be_success
      response.should render_template('new')
    end

    it "should create merchant" do 
      Merchant.should_receive(:new).with( :name => "merchant1", 
                                          :homepage => "www.test.com",
                                          :description => "testdescription",
                                          :affiliate_program_id => 1,
                                          :affiliate_code => "123abc")
      valid_create
    end

    it "should save the merchant" do 
      @merchant.should_receive(:save).and_return(true)
      valid_create
    end

    it "should redirect" do 
      valid_create
      response.should be_redirect
    end

    it "should assign gift" do
      valid_create
      assigns(:merchant).should == @merchant
    end

    it "should to the index path " do 
      valid_create
      response.should redirect_to(admin_gifting_merchant_url(@merchant))
    end

  end

  describe "creating an invalid merchant" do
    before(:each) do 
      Merchant.stub!(:new).and_return(@merchant = mock_model(Merchant, :save => false))
    end

    def invalid_create
      post :create, :merchant => { :name => "merchant1", 
                        :homepage => "www.test.com",
                        :description => "testdescription",
                        :affiliate_program_id => 1,
                        :affiliate_code => "123abc"}
    end

    it "should create the merchant" do
      Merchant.should_receive(:new).with( 'name' => "merchant1", 
                                      'homepage' => "www.test.com",
                                      'description' => "testdescription",
                                      'affiliate_program_id' => 1,
                                      'affiliate_code' => "123abc")
      invalid_create
    end

    it "should save the merchant" do 
      @merchant.should_receive(:save).and_return(false)
      invalid_create
    end

    it "should be success" do
      invalid_create
      response.should be_success
    end
    
    it "should assign merchant" do
      invalid_create
      assigns(:merchant).should == @merchant
    end

    it "should re-render the new form" do
      invalid_create
      response.should render_template("new")
    end
  end

  describe "Showing the merchant admin page" do
    before(:each) do 
      @merchant = mock_model(Merchant)
      Merchant.stub!(:find).with("1").and_return(@merchant)
    end

    it "assigns the requested merchant as @merchant" do
      Merchant.stub(:find).with("1") {@merchant}
      get :show, :id => "1"
      assigns(:merchant).should be(@merchant)
    end

  end

  describe "editing a merchant with valid params" do
    before(:each) do 
      @merchant = mock_model(Merchant, :update_attributes => true)
      Merchant.stub!(:find).with("1").and_return(@merchant)
    end

    it "assigns the requested merchant as @merchant" do
      Merchant.stub(:find).with("1") {@merchant}
      get :edit, :id => "1"
      assigns(:merchant).should be(@merchant)
    end

    it "should find merchant and return object" do 
      Merchant.should_receive(:find).with("1").and_return(@merchant)
      put :update, :id => "1", :merchant => {}
    end

    it "should update the merchant objects attributes" do
      @merchant.should_receive(:update_attributes).and_return(true)
      put :update, :id => "1", :merchant => {}
    end

    it "should have a flash notice" do
      put :update, :id => "1", :merchant => {}
      flash[:notice].should_not be_blank
    end

    it "should have a successful flash notice" do
      put :update, :id => "1", :merchant => {}
      flash[:notice].should eql 'Successfully updated merchant'
    end

    it "should redirect to the merchant's show page" do
      put :update, :id => "1", :merchant => {}
      response.should redirect_to(admin_gifting_merchants_url)
    end

  end

  describe "updating a merchant with invalid params" do
    before(:each) do 
      @merchant = mock_model(Merchant, :update_attributes => false)
      Merchant.stub!(:find).with("1").and_return(@merchant)
    end

    it "should find and return object" do
      Merchant.should_receive(:find).with("1").and_return(@merchant)
      put :update, :id => "1", :merchant => {}
    end

    it "should update the merchants objects attributes" do
      @merchant.should_receive(:update_attributes).and_return(false)
      put :update, :id => "1", :merchant => {}
    end

    it "should render the edit form" do
      put :update, :id => "1", :merchant => {}
      response.should render_template('edit')
    end
  end

  describe "deleting a merchant" do
    before(:each) do 
      @merchant = mock_model(Merchant)
      Merchant.stub!(:find).with("1").and_return(@merchant)
    end

    it "should destroy the requested merchant" do
      Merchant.should_receive(:find).with("1").and_return(@merchant)
      @merchant.should_receive(:destroy)
      delete :destroy, :id => "1"
    end

    it "should redirect on success" do
      Merchant.should_receive(:find).with("1").and_return(@merchant)
      delete :destroy, :id => "1"
      response.should redirect_to(admin_gifting_merchants_url)
    end

    it "should set flash[:notice] on success" do
      Merchant.should_receive(:find).with("1").and_return(@merchant)
      delete :destroy, :id => "1"
      flash[:notice].should eql 'Merchant has been deleted'
    end

    it "should redirect on failure" do
      Merchant.stub!(:find).and_return(@merchant = mock_model(Merchant, :destroy => false))
      delete :destroy, :id => "1"
      response.should redirect_to(admin_gifting_merchants_url)
    end

    it "should set flash[:notice] on failure" do
      Merchant.stub!(:find).and_return(@gift = mock_model(Merchant, :destroy => false))
      delete :destroy, :id => "1"
      flash[:notice].should eql 'Merchant has not been deleted'
    end

  end

  describe "access control to pages" do
    before(:each) do 
      sign_out @admin
    end

    describe "should allow users who are administrators" do
      before(:each) do
        sign_in @admin
      end

      it "should allow access to index" do
        get 'index'
        response.should_not be_redirect
      end

    end

    describe "users who are gift_editors" do
      before(:each) do
        @user = Factory(:user)
        @user.roles << Role.create(:name => "gift editor")
      end

      it "should have have the gift editor role, but not admin" do
        @user.has_role?(:admin).should be_false
        @user.has_role?('gift editor').should be_true
      end

      it "should allow access to index for user with gift role" do
        sign_in @user
        get 'index'
        response.should_not be_redirect
      end

      it "should allow access to edit for user with gift role" do
        sign_in @user
        merchant = Factory(:merchant)
        get 'edit', :id => merchant.id
        response.should_not be_redirect
      end
    end


    describe "standard users" do
      before(:each) do
        @user = Factory(:user)
        sign_in @user
      end
      
      it "should not have gift or editor roles" do
        @user.has_role?(:admin).should be_false
        @user.has_role?('gift editor').should be_false
      end

      it "should redirect from index for standard users" do
        get 'index'
        response.should redirect_to("/home")
      end

      it "should redirect from edit for standard users" do
        merchant = Factory(:merchant)
        get 'edit', :id => merchant.id
        response.should redirect_to("/home")
      end
      
    end

  end
end
