class Api::UsersController < ApiBaseController
  
  #skip_before_filter :prepend_around_filter, :only => [:create]
  respond_to :json
  
  def create
    @user = User.create params[:user]
    respond_with @user, :location => api_users_url
  end
  
end
