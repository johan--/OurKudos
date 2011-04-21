class AuthenticationsController < ApplicationController
  
  
  def index
  end
  
  def create
    auth = request.env["omniauth.auth"] 
    current_user.authentications.find_or_create_by_provider_and_uid :provider => auth['provider'], :uid => auth['uid']
    redirect_to authentications_url
  end
  
  def failed
  end
  
end
