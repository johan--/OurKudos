require 'spec_helper'

describe PasswordChangesController do

  describe "GET 'controller'" do
    it "should be successful" do
      get 'controller'
      response.should be_success
    end
  end

end
