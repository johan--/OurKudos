class IdentitiesController < ApplicationController
  before_filter :authenticate_user!

  respond_to :html, :js

  def new
    @identity = Identity.new
  end

  def create
    @identity = current_user.identities.build params[:identity]
    if @identity.save
      redirect_to user_path(current_user), :notice => I18n.t(:identity_created)
    else
      render :new
    end
  end

  def edit
    @identity = current_user.identities.find params[:id]
  end

  def update
    @identity = current_user.identities.find params[:id]
    if @identity.update_attributes params[:identity]
      redirect_to user_path(current_user), :notice => I18n.t(:identity_updated)
    else
      render :edit
    end
  end

  def destroy
    @identity = current_user.identities.find params[:id]
    if @identity.destroy
      redirect_to user_path(current_user), :notice => I18n.t(:identity_removed)
    else
      redirect_to user_path(current_user), :notice => I18n.t(:identity_not_removed)
    end
  end

end
