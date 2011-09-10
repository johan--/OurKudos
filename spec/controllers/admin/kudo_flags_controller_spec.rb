require 'spec_helper'

describe Admin::KudoFlagsController do

  describe "viewing flaged kudos" do
      before(:each) do
        @user = Factory(:user)
        sign_in @user
      end
    
    describe "the roles that can access kudo flags" do

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

    describe "validating a flag" do
      before(:each) do 
        @user.roles << Role.create(:name => "admin")
        @kudo = Factory(:kudo_flag)
      end

      it "should redirect when nothing is selected and no action is true" do
        @request.env['HTTP_REFERER'] = admin_kudo_flags_url
        KudoFlagAction.should_receive(:process_flag_action).and_return(true)
        put 'flag'
        response.should redirect_to(admin_kudo_flags_url)
        flash[:alert].should eq('Please select at least one kudo flag!')
      end

      it "should redirect when nothing is selected and no action is false" do
        KudoFlagAction.should_receive(:process_flag_action).and_return(false)
        put 'flag', :kudo_flags => {}
        response.should redirect_to(admin_kudo_flags_url)
        flash[:notice].should eq('Your Flag Actions Have Been Performed')
      end

      it "should mark the flagged kudo valid" do
        KudoFlagAction.should_receive(:process_flag_action).and_return(true)
        valid_params = {:kudo_flags => {@kudo.id.to_s => 'true'}}
        
        put 'flag', valid_params
        KudoFlag.all.should be_empty
        Kudo.count.should eq(0)
      end

      it "should mark the flagged kudo invalid" do
        #test not 100% valid
        KudoFlagAction.should_receive(:process_flag_action).and_return(true)
        valid_params = {:kudo_flags => {@kudo.id.to_s => 'false'}}
        put 'flag', valid_params
        KudoFlag.first.flag_valid.should be(false)
        Kudo.count.should eq(1)
      end

      it "should not show in the list after being validated" do
        KudoFlagAction.should_receive(:process_flag_action).and_return(true)
        valid_params = {:kudo_flags => {@kudo.id.to_s => 'true'}}
        put 'flag', valid_params
        get 'index'
        assigns[:kudo_flags].should_not include(@kudo)
      end
    end

    describe "flagging actions" do
      before(:each) do 
        @user.roles << Role.create(:name => "admin")
        @flag = Factory(:kudo_flag)
        @valid_params = { :kudo_flags => {@kudo.id.to_s => 'false'}}
      end

    end

    describe "submitting an empty form" do
      it "should redirect back to the index action" do
        put 'flag'
        response.should be_redirect
      end
    end

  end

end
