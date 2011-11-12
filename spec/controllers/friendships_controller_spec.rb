require 'spec_helper'

describe FriendshipsController do

  before(:each) do 
    @user = Factory(:user)
    sign_in @user
  end

end
