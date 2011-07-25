class ProfilesController < ApplicationController
  layout 'unregistered'

  def show
    redirect_to home_path if user_signed_in?
    @user = User.find params[:user_id]
  end


end
