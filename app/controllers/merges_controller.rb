class MergesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_if_confirmed, :only => [:show, :update]

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
         redirect_to new_merge_path, :notice => I18n.t(:merge_instructions_sent)
      else
        render :new
      end

    end
  end


  def show    
  end

  def update    
    @old_user = @merge.merged
    
    if @merge.merge_accounts
      redirect_to user_path(current_user), :notice => I18n.t(:you_have_successfuly_merged_your_accounts)
    else
      redirect_to user_path(current_user), :alert => I18n.t(:merge_unable_to_merge_accounts)
    end
  end

  private

    def check_if_confirmed
      @merge = Merge.find params[:id] rescue nil
      
      if @merge.blank? || (@merge && !@merge.confirmation.confirmed) || (@merge.merger != current_user)
        flash[:alert] = "#{I18n.t(:unable_to_confirm_identity)} #{I18n.t(:not_authorized_to_view_this_page)}"
        redirect_to new_merge_path
      end
      return true if @merge && @merge.confirmation.confirmed?
    end

end
