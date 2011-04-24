class UsersController < ApplicationController
  before_filter :authenticate_user!, :except => [:twitter_email]
  
  
  def show
    @user = current_user
    @authentications = current_user.authentications
  end
  
  def twitter_email
    @user = User.new params[:user]
    if request.post? 
      if @user.save
        flash[:notice] = "OK"
      else
        render :action => :twitter_email
      end  
    end
  end
  
  
  
  
end
