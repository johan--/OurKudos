class UsersController < ApplicationController
  before_filter :authenticate_user!
  layout 'registered'
  
  def show
    @user            = current_user
    @authentications = current_user.authentications
    @identities      = current_user.identities
  end
  
  
end
