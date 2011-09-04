require 'spec_helper'

describe Admin::KudoCategoriesController do

  describe "viewing Kudo Categories" do

    describe 'access control' do

      it "should redirect user without admin role" do
        user = Factory(:user)
        sign_in user
        get 'index'
        user.has_role?(:admin).should be_false
        response.should redirect_to("/home")
      end

      it "should redirect user without admin role" do
        admin = Factory(:admin_user)
        sign_in admin
        get 'index'
        admin.has_role?(:admin).should be_true
        response.should be_success
      end

    end

    describe "the kudo category index page" do
      before(:each) do
        @admin = Factory(:admin_user)
        sign_in @admin
      end

      it 'should assign existing kudo categories' do
        kudo_category = Factory(:kudo_category)
        get 'index'
        assigns[:kudo_categories].should include(kudo_category)
      end
        
      it "should assign a new kudo category object" do
        get 'index'
        assigns[:kudo_category].class.should eq(KudoCategory)
      end
    end

    describe 'creating a new kudo category' do
      before(:each) do
        @admin = Factory(:admin_user)
        sign_in @admin
        @valid_params = Factory.attributes_for(:kudo_category)
      end
 
      it 'should create a new kudo category' do
        lambda {
          post :create, :kudo_category => @valid_params
        }.should change(KudoCategory, :count).by(1)
      end

      it "should set Flash" do
        post :create, :kudo_category => @valid_params
        flash[:notice].should eq('Kudo category added')
      end

      it "should redirect to index after successful create " do
        post :create, :kudo_category => @valid_params
        response.should be_redirect
      end

    end

    describe "creating an invalid kudo category" do
      before(:each) do 
        @admin = Factory(:admin_user)
        sign_in @admin
        KudoCategory.stub!(:new).and_return(@category = mock_model(KudoCategory, :save => false))
        @invalid_params = { :name => ""}
      end

      def invalid_create
        post :create, :kudo_category => { :name => ""}
      end

      it "should create kudo category" do
        lambda {
          post :create, :kudo_category => @invalid_params
        }.should_not change(KudoCategory, :count)
      end

      it "should not save the kudo category" do 
        @category.should_receive(:save).and_return(false)
        invalid_create
      end

      it "should be success" do
        invalid_create
        response.should be_success
      end
      
      it "should assign kudo category" do
        invalid_create
        assigns(:kudo_category).should == @category
      end

      it "should re-render the new form" do
        invalid_create
        response.should render_template("index")
      end
    end

    describe "editing kudo category with valid params" do
      before(:each) do 
        @admin = Factory(:admin_user)
        sign_in @admin
        @category = mock_model(KudoCategory, :update_attributes => true)
        KudoCategory.stub!(:find).with("1").and_return(@category)
      end

      it "assigns the requested category as @category" do
        KudoCategory.stub(:find).with("1") {@category}
        get :edit, :id => "1"
        assigns(:kudo_category).should be(@category)
      end

      it "should find gift and return object" do 
        KudoCategory.should_receive(:find).with("1").and_return(@category)
        put :update, :id => "1", :kudo_category => {}
      end

      it "should update the kudo category objects attributes" do
        @category.should_receive(:update_attributes).and_return(true)
        put :update, :id => "1", :kudo_category => {}
      end

      it "should have a flash notice" do
        put :update, :id => "1", :kudo_category => {}
        flash[:notice].should_not be_blank
      end

      it "should have a successful flash notice" do
        put :update, :id => "1", :kudo_category => {}
        flash[:notice].should eql 'Successfully updated Kudo Category'
      end

      it "should redirect to the kudo category's show page" do
        put :update, :id => "1", :kudo_category => {}
        response.should redirect_to(admin_kudo_categories_url)
      end

    end
    describe "updating a kudo category with invalid params" do
      before(:each) do 
        @admin = Factory(:admin_user)
        sign_in @admin
        @category = mock_model(KudoCategory, :update_attributes => false)
        KudoCategory.stub!(:find).with("1").and_return(@category)
      end

      it "should find kudo category and return object" do
        KudoCategory.should_receive(:find).with("1").and_return(@category)
        put :update, :id => "1", :kudo_category => {}
      end

      it "should update the kudo category objects attributes" do
        @category.should_receive(:update_attributes).and_return(false)
        put :update, :id => "1", :kudo_category => {}
      end

      it "should render the edit form " do
        put :update, :id => "1", :kudo_category => {}
        response.should render_template('edit')
      end
    end

    describe "deleting a kudo category" do
      before(:each) do 
        @admin = Factory(:admin_user)
        sign_in @admin
        @category = mock_model(KudoCategory)
        KudoCategory.stub!(:find).with("1").and_return(@category)
      end
      it "should destroy the requested category" do
        KudoCategory.should_receive(:find).with("1").and_return(@category)
        @category.should_receive(:destroy)
        delete :destroy, :id => "1"
      end

      it "should redirect on success" do
        KudoCategory.should_receive(:find).with("1").and_return(@category)
        delete :destroy, :id => "1"
        response.should redirect_to(admin_kudo_categories_url)
      end

      it "should set flash[:notice] on success" do
        KudoCategory.should_receive(:find).with("1").and_return(@category)
        delete :destroy, :id => "1"
        flash[:notice].should eql 'Kudo Category has been successfully deleted'
      end

      it "should redirect on failure" do
        KudoCategory.stub!(:find).and_return(@category = mock_model(KudoCategory, :destroy => false))
        delete :destroy, :id => "1"
        response.should redirect_to(admin_kudo_categories_url)
      end

      it "should set flash[:notice] on failure" do
        KudoCategory.stub!(:find).and_return(@category = mock_model(KudoCategory, :destroy => false))
        delete :destroy, :id => "1"
        flash[:notice].should eql 'Error - Kudo Category has not been deleted'
      end

    end
      
  end
end
