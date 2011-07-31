require 'spec_helper'

describe GiftsController do

  context 'index action ' do
    before(:each) do 
      @group1 = Factory(:gift_group)
      @group2 = Factory(:gift_group)
      @gift = Factory(:gift, :gift_group_ids => [@group1.id])
    end

    it "should render index" do
      get 'index'
      response.should render_template('index')
    end

    it "should show only gift groups that have a gifts" do
      get 'index'
      assigns(:gift_groups).should include(@group1)
      assigns(:gift_groups).should_not include(@group2)
    end

    it "should show only show gifts for selected group" do
      gift2 = Factory(:gift, :gift_group_ids => [@group2.id])

      get 'index', {:gift_group => @group1.id}

      assigns(:gifts).should include(@gift)
      assigns(:gifts).should_not include(@gift2)
    end
  end

  it "should handle show properly" do
    @gift = Factory(:gift)
    get 'show', {:id => @gift.id}
    response.should be_success
  end
  
  context "list group in slider" do
    before(:each) do 
      @group = Factory(:gift_group)
      @gift1 = Factory(:gift, :gift_group_ids => [@group.id])
      @gift2 = Factory(:gift)
    end

    it "should show all gifts when 0 is passed in" do
      get "list_gifts_in_group_slider", :id => 0, :format => 'js'
      response.should be_success
      assigns(:gifts).should include(@gift1)
      assigns(:gifts).should include(@gift2)
    end

    it "should show only gifts for group id passed in" do
      get "list_gifts_in_group_slider", :id => @group.id, :format => 'js'
      response.should be_success
      assigns(:gifts).should include(@gift1)
      assigns(:gifts).should_not include(@gift2)
    end

  end

end
