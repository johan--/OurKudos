require 'spec_helper'

describe KudoFlagAction do
  describe 'creating a new action' do

    describe 'suspend author action' do
      before(:each) do
        @user = Factory(:user)
        @kudo = Factory(:kudo, :author => @user)
        @flag = Factory(:kudo_flag, :flagged_kudo => @kudo)
        @action = Factory(:kudo_flag_action, :kudo_flag => @flag)
      end

      it "should suspend the author" do
        @action.should respond_to('suspend_action') 
        @user.is_banned?.should be(false)
        @action.suspend_action
        @user.is_banned?.should be(true)
      end

    end

    describe 'delete author action' do
      before(:each) do
        @user = Factory(:user)
        @kudo = Factory(:kudo, :author => @user)
        @flag = Factory(:kudo_flag, :flagged_kudo => @kudo)
        @action = Factory(:kudo_flag_action, :kudo_flag => @flag)
      end

      it "should delete the author" do
        @action.should respond_to('delete_action') 
        @user.deleted_at.should be(nil)
        @action.delete_action
        @user.is_banned?.should_not be(nil)
      end

      it "should save the kudo flag action" do
        params = {'1' => {"current_user" => "1", "kudo_flag" => @flag.id, "action" => "delete"}}
        lambda {
          KudoFlagAction.process_flag_action params
        }.should change(KudoFlagAction, :count).by(1)
      end

    end

  end

  describe "invalid actions" do
    it "should not create action on no action" do
      params = {'1' => {"current_user" => "1", "kudo_flag" => "10", "action" => "no_action"}}
      lambda {
      KudoFlagAction.process_flag_action params
      }.should_not change(KudoFlagAction, :count)
    end

  end

end
