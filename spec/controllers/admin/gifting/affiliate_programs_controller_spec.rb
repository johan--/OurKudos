require 'spec_helper'

describe Admin::Gifting::AffiliateProgramsController do

  before(:each) do 
    @admin = Factory(:admin_user)
    sign_in @admin
  end

  describe "index page" do
    before(:each) do
      @affiliate_program = Factory(:affiliate_program)
      get 'index'
    end

    it "should render index template" do
      response.should render_template('index')
    end

    it "should assign affiliate programs to @affiliate_programs" do
      assigns(:affiliate_programs).should include(@affiliate_program)
    end

    it "should assign new affiliate program to @affiliate_program" do
      assigns(:affiliate_program).should be_an_instance_of(AffiliateProgram)
    end

  end

  describe "creating a new affiliate program" do 
    before(:each) do 
      AffiliateProgram.stub!(:new).and_return(@affiliate_program = mock_model(AffiliateProgram, :save => true))
    end

    def valid_create
      post :create, :affiliate_program => { :name => "program1", 
                        :homepage => "www.test.com"}
    end


    it "should create affiliate program" do 
      AffiliateProgram.should_receive(:new).with( 'name' => "program1", 
                                      'homepage' => "www.test.com")
      valid_create
    end

    it "should save the affiliate program" do 
      @affiliate_program.should_receive(:save).and_return(true)
      valid_create
    end

    it "should redirect" do 
      valid_create
      response.should be_redirect
    end

    it "should assign affiliate program" do
      valid_create
      assigns(:affiliate_program).should == @affiliate_program
    end

    it "should to the index path " do 
      valid_create
      response.should redirect_to(admin_gifting_affiliate_programs_url)
    end
  end

  describe "creating an invalid affiliate program" do
    before(:each) do 
      AffiliateProgram.stub!(:new).and_return(@affiliate_program = mock_model(AffiliateProgram, :save => false))
    end

    def invalid_create
      post :create, :affiliate_program => { :name => "program1", 
                        :homepage => "www.test.com"}
    end

    it "should create the affiliate program" do
      AffiliateProgram.should_receive(:new).with( 'name' => "program1", 
                                      'homepage' => "www.test.com")
      invalid_create
    end

    it "should save the affiliate program" do 
      @affiliate_program.should_receive(:save).and_return(false)
      invalid_create
    end

    it "should be success" do
      invalid_create
      response.should be_success
    end
    
    it "should assign affiliate program" do
      invalid_create
      assigns(:affiliate_program).should == @affiliate_program
    end

    it "should re-render the index page" do
      invalid_create
      response.should render_template("index")
    end
  end

  describe "deleting an affiliate programs" do
    before(:each) do 
      @affiliate_program = mock_model(AffiliateProgram)
      AffiliateProgram.stub!(:find).with("1").and_return(@affiliate_program)
    end

    it "should destroy the requested affiliate program" do
      AffiliateProgram.should_receive(:find).with("1").and_return(@affiliate_program)
      @affiliate_program.should_receive(:destroy)
      delete :destroy, :id => "1"
    end

    it "should redirect on success" do
      AffiliateProgram.should_receive(:find).with("1").and_return(@affiliate_program)
      delete :destroy, :id => "1"
      response.should redirect_to(admin_gifting_affiliate_programs_url)
    end

    it "should set flash[:notice] on success" do
      AffiliateProgram.should_receive(:find).with("1").and_return(@affiliate_program)
      delete :destroy, :id => "1"
      flash[:notice].should eql 'Affiliate Program has been deleted'
    end

    it "should redirect on failure" do
      AffiliateProgram.stub!(:find).and_return(@affiliate_program = mock_model(AffiliateProgram, :destroy => false))
      delete :destroy, :id => "1"
      response.should redirect_to(admin_gifting_affiliate_programs_url)
    end

    it "should set flash[:notice] on falure" do
      AffiliateProgram.stub!(:find).and_return(@affiliate_program = mock_model(AffiliateProgram, :destroy => false))
      delete :destroy, :id => "1"
      flash[:notice].should eql 'Affiliate Program has not been deleted'
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
        @user.roles << Role.create(:name => "gift")
      end

      it "should have have the gift editor role, but not admin" do
        @user.has_role?(:admin).should be_false
        @user.has_role?(:gift).should be_true
      end

      it "should allow access for user with gift role" do
        sign_in @user
        get 'index'
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
        @user.has_role?(:gift).should be_false
      end

      it "should redirect for standard users" do
        get 'index'
        response.should redirect_to(root_path)
      end
      
    end

  end

end
