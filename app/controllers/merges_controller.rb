class MergesController < ApplicationController
  before_filter :authenticate_user!

  def new
    @merge = Merge.new
  end

  def create
    @identity = Identity.find_by_identity params[:identity]
    if params[:identity].blank? || @identity.blank?
      redirect_to new_merge_path, :alert => I18n.t(:please_enter_valid_identity)   
    else
      @merge = Merge.accounts current_user, @identity
      if @merge.save
      else
      end
    end
  end
  
end
