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

  def destroy
    if current_user.remove_system_avatar!
      redirect_to home_path, :notice => I18n.t(:profile_picture_removed)
    else
      render home_path, :alert => I18n.t(:unable_to_remove_that_picture)
    end
  end

  def order
    if request.format.html?
      render :order
    else
      unless params[:order].blank?
        current_user.set_new_profile_pictures_order params[:order], true
        render 'order'
      else
        render :nothing => true
      end
     end
  end

end
