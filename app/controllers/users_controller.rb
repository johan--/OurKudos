class UsersController < ApplicationController
  before_filter :authenticate_user!, :except => [:twitter_email]
  
  
  def show
    @user = current_user
    @authentications = current_user.authentications
  end
  
  def twitter_email
    @user = User.new
    @user.apply_omniauth(session[:omniauth])
    if request.post? 
      @user.email = params[:user][:email] if params[:user]
      if @user.save         
        flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => 'twitter'
        sign_in_and_redirect(:user, @user)
        session[:omniauth] = nil #removes data from session after save
      else
        render :action => :twitter_email
      end  
    end
  end
  
  
  
  
end
