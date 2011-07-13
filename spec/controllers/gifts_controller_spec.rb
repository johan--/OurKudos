require 'spec_helper'

describe GiftsController do

  it "should render index" do
    get 'index'
    response.should render_template('index')
  end

  it "should handle show properly" do
    #needs a gift created
    @gift = Factory(:gift)
    get 'show', {:id => @gift.id}
    response.should be_success
  end
  
  context "list group in slider" do
    before(:each) do 
      @group = Factory(:gift_group)
      @gift1 = Factory(:gift, :name => 'Gift1')
#@gift2 = Factory(:gift, :name => 'Gift2')
    end

    it "should show all gifts when 0 is passed in" do
      get "list_gifts_in_group_slider", :id => 0, :format => 'js'
#need to test to make sure both gifts are shown
      response.should be_success
    end

    it "should show only gifts for group id passed in" do
      get "list_gifts_in_group_slider", :id => @group.id, :format => 'js'
#need to test to make sure only gift in group gift shown
      response.should be_success
    end
  end

end
