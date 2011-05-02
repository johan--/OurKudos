class AuthenticationsController < ApplicationController
  before_filter :authenticate_user!, :only => [:index, :new, :edit]
  
  respond_to :html, :js
  
  def index
    @authentications = current_user.authentications
  end
  
  def new
    @authentication = current_user.authentications.new 
  end
  
  def edit
    @authentication = current_user.authentications.find params[:id]
  end
  
  def create
    @authentication = current_user.authentications.new params[:authentication]
    if @authentication.save 
      redirect_to user_path(current_user), :notice => t(:authentication_has_been_added)
    else  
      render :action => :new
    end  
  end
  
  def update
    @authentication = current_user.authentications.find params[:id]
    if @authentication.update_attributes params[:authentication] 
      redirect_to user_path(current_user), :notice => t(:authentication_has_been_updated)
    else  
      render :action => :edit
    end
  end
  
  def destroy
    @authentication = current_user.authentications.find params[:id]
    if @authentication.destroy
      redirect_to user_path(current_user), :notice => t(:authentication_has_been_removed)
    else
      redirect_to user_path(current_user), :notice => t(:unable_to_remove_authentication)
    end  
  end
  
  def failed
    render :text => request.env.to_yaml
  end
  
end
