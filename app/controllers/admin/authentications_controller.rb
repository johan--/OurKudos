class Admin::AuthenticationsController < Admin::AdminController
  before_filter :authenticate_user!
  
  
  def edit
    @authentication = Authentication.find params[:id]
    @submit_url = admin_user_authentication_path(@authentication.user, @authentication)
    render :template => "/authentications/edit"
  end
  
  def update
    @authentication = Authentication.find params[:id]
    if @authentication.update_attributes params[:authentication] 
      redirect_to admin_user_path(@authentication.user, @authentication), :notice => t(:authentication_has_been_updated)
    else  
      render :action => :edit
    end
  end
  
  def destroy
    @authentication = Authentication.find params[:id]
    if @authentication.destroy
      redirect_to admin_user_path(@authentication.user), :notice => t(:authentication_has_been_removed)
    else
      redirect_to admin_user_path(@authentication.user), :notice => t(:unable_to_remove_authentication)
    end
  end
  
  
  
end
