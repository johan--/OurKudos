class UsersController < ApplicationController
  before_filter :authenticate_user!
  layout 'registered'
  
  def show
    @user            = current_user
    @user
    @authentications = current_user.authentications
    @identities      = current_user.identities
    @kudos           = current_user.inbox.kudos.page(params[:page]).per(5)
  end
  
  
end
