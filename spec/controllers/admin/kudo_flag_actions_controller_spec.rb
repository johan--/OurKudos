require 'spec_helper'

describe Admin::KudoFlagActionsController do

  before :all do
    Settings.seed!
  end

  describe 'create new kudo flag action' do 
    before(:each) do
      @admin = Factory(:user)
      @admin.roles << Role.create(:name => "admin")
      sign_in @admin
    end

    it "should create a new record on post" do
      user = Factory(:user)
      kudo = Factory(:kudo, :author_id => user.id)
      kudo_flag = Factory(:kudo_flag, :kudo_id => kudo.id)
      params = {:kudo_flag_id => kudo_flag.id, 
                :admin_user_id => @admin.id,
                :action_taken => "Suspend User"}

      post :create, :kudo_flag_action => params

      KudoFlagAction.count.should eq(1)
    end

  end

end

