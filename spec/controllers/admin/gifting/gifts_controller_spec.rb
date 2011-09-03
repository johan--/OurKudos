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

  describe "creating a valid gift" do
    before(:each) do 
      @valid_params = { :name => "gift1", 
                        :description => "testdescription",
                        :price => 1.00,
                        :link => "link",
                        :active => true,
                        :affiliate_code => "123abc"}

    end

    def valid_create
      post :create, :gift => @valid_params
    end

    it "should render new and assign new gift" do 
      get 'new'
      assigns(:gift).class.should == Gift
      response.should be_success
      response.should render_template('new')
    end

    it "should create gift" do
      lambda {
        post :create, :gift => @valid_params
      }.should change(Gift, :count).by(1)
    end

    it "should save the gift" do 
      Gift.stub!(:new).and_return(@gift = mock_model(Gift, :save => true))
      @gift.should_receive(:save).and_return(true)
      valid_create
    end

    it "should redirect" do 
      valid_create
      response.should be_redirect
    end

    it "should assign gift" do
      Gift.stub!(:new).and_return(@gift = mock_model(Gift, :save => true))
      valid_create
      assigns(:gift).should == @gift
    end

    it "should to the index path " do 
      Gift.stub!(:new).and_return(@gift = mock_model(Gift, :save => true))
      valid_create
      response.should redirect_to(admin_gifting_gift_url(@gift))
    end
  end

  
  describe "creating an invalid gift" do
    before(:each) do 
      Gift.stub!(:new).and_return(@gift = mock_model(Gift, :save => false))
      @invalid_params = { :name => "gift1", 
                        :description => "testdescription",
                        :price => 'abd',
                        :link => "link",
                        :active => true,
                        :affiliate_code => "123abc"}
    end

    def invalid_create
      post :create, :gift => { :name => "gift1", 
                        :description => "testdescription",
                        :price => 1.00,
                        :link => "link",
                        :active => true,
                        :affiliate_code => "123abc"}
    end

    it "should create gift" do
      lambda {
        post :create, :gift => @invalid_params
      }.should_not change(Gift, :count).by(1)
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

    it "should set flash[:notice] on failure" do
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
        gift = Factory(:gift)
        get 'edit', :id => gift.id
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
        gift = Factory(:gift)
        get 'edit', :id => gift.id
        response.should redirect_to("/home")
      end
      
    end

  end
end
