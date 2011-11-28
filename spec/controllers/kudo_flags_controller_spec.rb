require 'spec_helper'

describe KudoFlagsController do


  describe "creating a flag" do
    before(:each) do 
      @user = Factory(:user)
      sign_in @user
    end

    def valid_create
      kudo = Factory(:kudo)
      valid_params = {"flag_reason"=>"spam"}
      post :create, :kudo_id => kudo.id, :kudo_flag => valid_params, :format => 'js'
    end

    it "should render new and assign new kudo flag" do 
      kudo = mock_model(Kudo)
      flag = mock_model(KudoFlag)
      Kudo.stub!(:find).with('1').and_return(kudo)
      valid_params = Factory.attributes_for(:kudo_flag, :flagged_kudo => kudo)
      subject.current_user.kudo_flags.stub!(:build).and_return(flag)
      get :new, :kudo_id => '1', :format => 'js'
      assigns(:kudo_flag).class.should eq(KudoFlag)
      response.should be_success
    end

    it "should create flag" do
      kudo = Factory(:kudo)
      valid_params = {"flag_reason"=>"spam"}
      lambda {
        valid_create
      }.should change(KudoFlag, :count).by(1)
    end
  end

end
