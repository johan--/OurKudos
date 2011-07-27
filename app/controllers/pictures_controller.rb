class PicturesController < ApplicationController
  layout 'registered'
  before_filter :authenticate_user!

  def index
    @pictures = current_user.pictures.order("ID DESC")
  end

  def new
    @picture = current_user.pictures.new
  end

  def create
    @picture = current_user.pictures.build params[:picture]

    if @picture.save
      redirect_to user_pictures_path(current_user), :notice => I18n.t(:picture_has_been_successfully_uploaded)
    else
      render :new
    end
  end



end
