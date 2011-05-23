class Api::UsersController < ApiBaseController
  #before_filter :authenticate!
  
  
  def index
    @users = User.all
    respond_with @users, :location => api_users_url
  end
  
 
    
  
end
