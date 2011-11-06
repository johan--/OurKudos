class VirtualMergesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_if_confirmed, :only => [:show, :update]
  layout 'registered'
  
  def new
    @merge = Merge.new
    @virtual_merge = VirtualMerge.new
  end

  def create
    identity = params[:identity]
    identity = identity[1..-1] if identity[0] == "@"
    @identity = Identity.find_by_identity identity

    @merge = VirtualMerge.accounts current_user, @identity
    if @merge.save        
      message = I18n.t(:merge_instructions_sent) if @identity.identity_type != 'twitter'
      message = 'Your Twitter account has been merged' if @identity.identity_type = 'twitter'
      redirect_to user_path(current_user), :notice => message
    else
      message = I18n.t(:please_authorize_with_twitter_before_adding) if @identity.identity_type = 'twitter'
      message = 'There was a problem merging you account' if @identity.identity_type != 'twitter'
       redirect_to new_merge_path, :alert => message
    end
  end


  def show    
  end

  def update    
    if @merge.run!
      redirect_to user_path(current_user), :notice => I18n.t(:you_have_successfuly_merged_your_accounts)
    else
      redirect_to user_path(current_user), :alert => I18n.t(:merge_unable_to_merge_accounts)
    end
  end

  private

    def check_if_confirmed
      @merge = VirtualMerge.find params[:id] rescue nil
      
      if @merge.blank? || (@merge && !@merge.confirmation.confirmed) || (@merge.merger != current_user)
        flash[:alert] = "#{I18n.t(:unable_to_confirm_identity)} #{I18n.t(:not_authorized_to_view_this_page)}"
        redirect_to new_merge_path
      end
      return true if @merge && @merge.confirmation.confirmed?
    end

end
