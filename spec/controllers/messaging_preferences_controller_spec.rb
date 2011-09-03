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
    
    it "should redirect to edit on failed save" do
      @messaging_preference = mock_model(MessagingPreference, :update_attributes => false)
      MessagingPreference.stub!(:find_by_user_id).and_return(@messaging_preference)
      put :update, :id => "1", :messaging_preference => {}
      response.should render_template('edit')
    end
  end

end
