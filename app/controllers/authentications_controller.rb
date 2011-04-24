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
     render :text => request.env["omniauth.auth"].to_yaml  
   # @authentication = current_user.authentications.new params[:authentication]
    #if @authentication.save 
     # redirect_to user_path(current_user), :notice => t(:authentication_has_been_added)
    #else  
    #  render :action => :new
    #end  
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
  
  def callback
    auth = request.env["omniauth.auth"] 
    debugger
    current_user.authentications.find_or_create_by_provider_and_uid :provider => auth['provider'], :uid => auth['uid']
    redirect_to authentications_url
  end
  
  def failed
    render :text => request.env.to_yaml
  end
  
end
