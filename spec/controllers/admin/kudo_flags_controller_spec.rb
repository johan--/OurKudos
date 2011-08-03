require 'spec_helper'

describe Admin::KudoFlagsController do

  describe "viewing flaged kudos" do
    
    describe "the roles that can access kudo flags" do
      before(:each) do
        @user = Factory(:user)
        sign_in @user
      end

      it "should redirect user without admin or kudo editor role" do
        get 'index'
        @user.has_role?(:admin).should be_false
        @user.has_role?('gift editor').should be_false
        response.should redirect_to("/home")
      end

      it "should allow access to kudo editors" do
        @user.roles << Role.create(:name => "kudo editor")
        get 'index'
        response.should_not be_redirect
      end

      it "should allow access to admins" do
        @user.roles << Role.create(:name => "admin")
        get 'index'
        response.should_not be_redirect
      end

    end

  end

  describe "taking action on flagged kudos" do

  end

end
