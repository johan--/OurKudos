class UsersController < ApplicationController
  before_filter :authenticate_user!
  
  
  def show
    @user = current_user
    @authentications = current_user.authentications
  end
  
  
  
  
end
