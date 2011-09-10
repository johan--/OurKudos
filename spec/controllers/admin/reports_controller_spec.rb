require 'spec_helper'

describe Admin::ReportsController do

  before(:all) do 
    Settings.seed!
  end

  before(:each) do 
    @admin = Factory(:admin_user)
    sign_in @admin
  end

  it "should render index" do
    get 'index'
    response.should render_template('index')
    assigns(:reports).should_not be_nil
  end

  it "assigns the requested report as @report" do
    @report = double(Report)
    Report.stub(:find).with("1") {@return}
    get :show, :id => "1"
    assigns(:report).should be(@return)
  end

end
