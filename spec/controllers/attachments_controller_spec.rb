require 'spec_helper'

describe AttachmentsController do

  before(:each) do
    @attachment = Attachment.create(:name => "attach1", 
                                    :description => "testdescription",
                                    :attachment => fixture_file_upload('/assets/HappyChrismah.gif', 'image/gif'))
  end

  it "should render index" do
    get 'index'
    response.should render_template('index')
    assigns(:attachments).should_not be_nil
  end

  it 'should show attachment' do
    get :show, :id => @attachment.id
    assigns[:attachment].should eq(@attachment)
  end

  it 'should render show for html' do
    get :show, :id => @attachment.id, :format => :html
    response.should render_template('show')
  end

  it 'should render attachment for js' do
    get :show, :id => @attachment.id, :format => :js
    response.should render_template('attachment')
  end

end
