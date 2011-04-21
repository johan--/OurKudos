class AuthenticationsController < ApplicationController
  
  respond_to :html, :js
  
  def index
    @authentications = current_user.authentications
  end
  
  def new
    @authentication = current_user.authentications.new 
  end
  
  def create
    @authentication = current_user.authentications.new params[:authentication]
    if @authentication.save 
      redirect_to user_path(current_user), :notice => t(:authentication_has_been_added)
    else  
      render :action => :new
    end  
  end
  
  def callback
    auth = request.env["omniauth.auth"] 
    current_user.authentications.find_or_create_by_provider_and_uid :provider => auth['provider'], :uid => auth['uid']
    redirect_to authentications_url
  end
  
  def failed
    render :text => pp(request.env)
  end
  
end
