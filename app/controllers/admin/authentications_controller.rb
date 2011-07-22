class Admin::AuthenticationsController < Admin::AdminController
  before_filter :authenticate_user!
  before_filter :get_user
  load_and_authorize_resource

  def new
    @user.authentications.new
  end
  
  def create
    @authentication = @user.authentications.new params[:authentication]
    if @authentication.save 
      redirect_to admin_user_path(@user), :notice => t(:authentication_has_been_added)
    else  
      render :action => :new
    end  
  end

  def edit
    @authentication = Authentication.find params[:id]
    @submit_url = admin_user_authentication_path(@user, @authentication)
  end
  
  def update
    @authentication = Authentication.find params[:id]
    if @authentication.update_attributes params[:authentication] 
      redirect_to admin_user_path(@user, @authentication), :notice => t(:authentication_has_been_updated)
    else  
      render :action => :edit
    end
  end
  
  def destroy
    @authentication = Authentication.find params[:id]
    if @authentication.destroy
      redirect_to admin_user_path(@user), :notice => t(:authentication_has_been_removed)
    else
      redirect_to admin_user_path(@user), :notice => t(:unable_to_remove_authentication)
    end
  end
  
    private

    def get_user
      @user = User.find params[:user_id]
    end
  
end
