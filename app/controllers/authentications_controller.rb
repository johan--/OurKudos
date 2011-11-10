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
  
  def find_from_email
  	
  	user = User.find_by_email params[:email].downcase
  	@authentications = user.authentications if user
  	if @authentications
  		twitter_found = false
  		facebook_found = false
  		both_found = false
  		@authentications.each do |authentication|
  			twitter_found = true if authentication.provider == "twitter"
  			facebook_found = true if authentication.provider == "facebook"
  		end
  		
  		render :text => t(:you_can_sign_in_with_facebook_or_twitter) and return if twitter_found && facebook_found
  		render :text => t(:you_can_sign_in_with_facebook) and return if facebook_found
  		render :text => t(:you_can_sign_in_with_twitter) and return if twitter_found
  		
  	end
  	
  	render :nothing => true
  	
  end
  
end