class AuthenticationsController < ApplicationController
  before_filter :authenticate_user!, :only => [:index, :new, :edit]
  
  respond_to :html, :js
  
  def destroy
    @authentication = (current_user.authentications.find params[:id]) 
                    
    if @authentication.destroy
       @authentication.user.facebook_friends.destroy_all if @authentication.facebook?
      redirect_to user_path(current_user), :notice => t(:authentication_has_been_removed)
    else
      redirect_to user_path(current_user), :notice => t(:unable_to_remove_authentication)
    end  
  end
  
end