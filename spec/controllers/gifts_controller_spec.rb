require 'spec_helper'

describe GiftsController do

  it "should render index" do
    get 'index'
    response.should render_template('index')
  end

  it "should handle show properly"

  it "should handle new properly"

  it "should handle edit properly"

  it "should handle destroy properly"

end
