require 'spec_helper'

describe Admin::AttachmentsController do

  before(:each) do 
    @admin = Factory(:admin_user)
    sign_in @admin
  end

  it "should render index" do
    get 'index'
    response.should render_template('index')
    assigns(:attachments).should_not be_nil
  end

  describe "creating a valid attachment" do
    before(:each) do 
      @valid_params = { :name => "attach1", 
                        :description => "testdescription",
                        :attachment => fixture_file_upload('/assets/HappyChrismah.gif', 'image/gif')}

    end

    def valid_create
      post :create, :attachment => @valid_params
    end

    it "should render new and assign new attachment" do 
      get 'new'
      assigns(:attachment).class.should eq(Attachment)
      assigns(:attachment).new_record?.should be_true
      response.should be_success
      response.should render_template('new')
    end

    it "should create attachment" do
      lambda {
        post :create, :attachment => @valid_params
      }.should change(Attachment, :count).by(1)
    end

    it "should save the Attachment" do 
      Attachment.stub!(:new).and_return(@attachment = mock_model(Attachment, :save => true))
      @attachment.should_receive(:save).and_return(true)
      valid_create
    end

    it "should redirect" do 
      valid_create
      response.should be_redirect
    end

    it "should assign attachment" do
      Attachment.stub!(:new).and_return(@attachment = mock_model(Attachment, :save => true))
      valid_create
      assigns(:attachment).should eq(@attachment)
    end

    it "should redirect to the attachment path " do 
      Attachment.stub!(:new).and_return(@attachment = mock_model(Attachment, :save => true))
      valid_create
      response.should redirect_to(admin_attachment_url(@attachment))
    end
  end

  
  describe "creating an invalid attachment" do
    before(:each) do 
      Attachment.stub!(:new).and_return(@attachment = mock_model(Attachment, :save => false))
      @invalid_params = { :name => "attach1"}
    end

    def invalid_create
      post :create, :attachment => { :name => "attach1"}
    end

    it "should not create attachment" do
      lambda {
        post :create, :attachment => @invalid_params
      }.should_not change(Attachment, :count).by(1)
    end

    it "should not save the gift" do 
      @attachment.should_receive(:save).and_return(false)
      invalid_create
    end

    it "should be success" do
      invalid_create
      response.should be_success
    end
    
    it "should assign attachment" do
      invalid_create
      assigns(:attachment).should eq(@attachment)
    end

    it "should re-render the new form" do
      invalid_create
      response.should render_template("new")
    end
  end

  describe "Showing the attachment admin page" do
    before(:each) do 
      @attachment = mock_model(Attachment)
      Attachment.stub!(:find).with("1").and_return(@attachment)
    end

    it "assigns the requested attachment as @attachment" do
      Attachment.stub(:find).with("1") {@attachment}
      get :show, :id => "1"
      assigns(:attachment).should be(@attachment)
    end
  end
  


  describe "editing an attachment with valid params" do
    before(:each) do 
      @attachment = mock_model(Attachment, :update_attributes => true)
      Attachment.stub!(:find).with("1").and_return(@attachment)
    end

    it "assigns the requested attachment as @attachment" do
      Attachment.stub(:find).with("1") {@attachment}
      get :edit, :id => "1"
      assigns(:attachment).should be(@attachment)
    end

    it "should find attachment and return object" do 
      Attachment.should_receive(:find).with("1").and_return(@attachment)
      put :update, :id => "1", :attachment => {}
    end

    it "should update the attachment objects attributes" do
      @attachment.should_receive(:update_attributes).and_return(true)
      put :update, :id => "1", :attachment => {}
    end

    it "should have a flash notice" do
      put :update, :id => "1", :attachment => {}
      flash[:notice].should_not be_blank
    end

    it "should have a successful flash notice" do
      put :update, :id => "1", :attachment => {}
      flash[:notice].should eq('Successfully updated card')
    end

    it "should redirect to the attachment's show page" do
      put :update, :id => "1", :attachment => {}
      response.should redirect_to(admin_attachment_url(@attachment))
    end
  end

  describe "updating a attachment with invalid params" do
    before(:each) do 
      @attachment = mock_model(Attachment, :update_attributes => false)
      Attachment.stub!(:find).with("1").and_return(@attachment)
    end

    it "should find attachment and return object" do
      Attachment.should_receive(:find).with("1").and_return(@attachment)
      put :update, :id => "1", :attachment=> {}
    end

    it "should update the attachment objects attributes" do
      @attachment.should_receive(:update_attributes).and_return(false)
      put :update, :id => "1", :attachment => {}
    end

    it "should render the edit form " do
      put :update, :id => "1", :attachment => {}
      response.should render_template('edit')
    end
  end

  describe "deleting a attachment" do
    before(:each) do 
      @attachment = mock_model(Attachment)
      Attachment.stub!(:find).with("1").and_return(@attachment)
    end
    it "should destroy the requested attachment" do
      Attachment.should_receive(:find).with("1").and_return(@attachment)
      @attachment.should_receive(:destroy)
      delete :destroy, :id => "1"
    end

    it "should redirect on success" do
      Attachment.should_receive(:find).with("1").and_return(@attachment)
      delete :destroy, :id => "1"
      response.should redirect_to(admin_attachments_url)
    end

    it "should set flash[:notice] on success" do
      Attachment.should_receive(:find).with("1").and_return(@attachment)
      delete :destroy, :id => "1"
      flash[:notice].should eql 'Card has been deleted'
    end

    it "should redirect on failure" do
      Attachment.stub!(:find).and_return(@attachment = mock_model(Attachment, :destroy => false))
      delete :destroy, :id => "1"
      response.should redirect_to(admin_attachments_url)
    end

    it "should set flash[:notice] on failure" do
      Attachment.stub!(:find).and_return(@attachment = mock_model(Attachment, :destroy => false))
      delete :destroy, :id => "1"
      flash[:notice].should eql 'Card was not deleted'
    end

  end



end
