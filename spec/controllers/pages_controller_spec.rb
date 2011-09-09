require 'spec_helper'

describe PagesController do

  before(:all) do 
    Settings.seed!
  end

  describe "Showing the a page" do
    it "assigns the requested page as @page" do
      @page = mock_model(Page)
      Page.stub!(:find_with_locale).with("1", :en).and_return(@page)
      Page.stub(:find).with("1",:en) {@page}
      get :show, :id => "1"
      assigns(:page).should be(@page)
    end

    it "assigns should render 404 if @page is blank" do
      Page.stub!(:find_with_locale).with("1", :en).and_return(nil)
      get :show, :id => "1"
      response.should be_not_found
    end

  end
end
