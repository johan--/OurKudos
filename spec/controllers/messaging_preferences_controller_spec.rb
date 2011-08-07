require 'spec_helper'

describe MessagingPreferencesController do


  describe "editing" do
    before(:each) do
      @user = Factory(:user)
      sign_in @user
    end

    it "should be successful" do
      get 'edit', :id => @user.id
      response.should be_success
    end

    it 'should update system email preference' do
      valid_params = { :user_id => @user.id,
                       :system_kudo_email => false}
      put :update, :id => @user.id, :messaging_preference => valid_params
      @user.messaging_preference.system_kudo_email.should eq(false)

    end
    
    #need a test to test a failed save
  end

end
