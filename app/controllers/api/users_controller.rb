class Api::UsersController < ApiBaseController
  
  respond_to :json
  
  def create
    @user = User.new params[:user]
    respond_with @user
  end
  
end
