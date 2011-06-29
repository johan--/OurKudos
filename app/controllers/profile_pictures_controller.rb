class ProfilePicturesController < ApplicationController
  before_filter :authenticate_user!
  layout "registered"


  def new
  end

  def create
    current_user.skip_password_validation = true
    if current_user.update_attributes params[:user]
      redirect_to home_path, :notice => I18n.t(:profile_picture_uploaded)
    else
      render :new
    end
  end

end
