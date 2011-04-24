class UsersController < ApplicationController
  before_filter :authenticate_user!, :except => [:twitter_email]
  
  
  def show
    @user = current_user
    @authentications = current_user.authentications
  end
  
  def twitter_email
    @user = User.find params[:id]
    if request.post? 
      if @user.save
        flash[:notice] = "OK"
      else
        render :action => :twitter_email
      end  
    end
  end
  
  
  
  
end
