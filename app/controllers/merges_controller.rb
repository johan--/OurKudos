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
         UserNotifier.deliver_confirm_your_identity_for_merge_process(@merge).deliver!
         redirect_to new_merge_path, :notice => I18n.t(:merge_instructions_sent)
      else
        render :new
      end

    end
  end

  def confirm
    @merge = Merge.find_by_key params[:key]
    @merge.set_as_confirmed!
    if @merge.email_confirmed?
      redirect_to merge_path(@merge), :notice => I18n.t(:merge_identity_confirmed)
    else
      redirect_to merge_path(@merge), :alert => I18n.t(:unable_to_confirm_identity)
    end
  end

  def show    
  end

  def update
    @old_user = @merge.merged
    
    if @old_user.give_mergeables_to current_user
      redirect_to user_path(current_user), :notice => I18n.t(:you_have_successfuly_merged_your_accounts)
    else
      redirect_to user_path(current_user), :alert => I18n.t(:merge_unable_to_merge_accounts)
    end
  end

  private

    def check_if_confirmed
      @merge = Merge.find params[:id]

      return false if @merge.blank? || (@merge && !@merge.email_confirmed) || (@merge.merger != current_user)
      return true if @merge && @merge.email_confirmed?
    end

end
