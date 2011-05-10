class MergesController < ApplicationController
  before_filter :authenticate_user!

  def new
  end

  def create
    @identity = Identity.find_by_identity params[:identity]
    if @identity.blank?
      redirect_to new_merge_path, :alert => I18n.t(:no_identity_found)
    elsif @identity && @identity.mergeable?
      redirect_to new_merge_path, :alert => I18n.t(:cannot_merge_that_account)
    else
      #TODO RUN MERGE LOGIC HANDLED BY MODEL
    end
  end
  
end
