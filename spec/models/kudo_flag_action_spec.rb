require 'spec_helper'

describe KudoFlagAction do
  describe 'creating a new action' do

    describe 'suspend author action' do
      before(:each) do
        @user = Factory(:user)
        @flag = Factory(:kudo_flag)
      end

      it "should suspend the author"

    end

    describe 'delete author action' do
      it "should delete the author"
    end

  end

  describe "invalid actions" do
    it "should not create action on no action"
    it "should not have an empty action"
  end

end
