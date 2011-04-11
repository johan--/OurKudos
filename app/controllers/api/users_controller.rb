class Api::UsersController < ApiBaseController
  
  skip_prepend_around_filter :only => [:create]
  respond_to :json
  
  def create
    @user = User.new params[:user]
    respond_with @user
  end
  
end
