class VirtualMergesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_if_confirmed, :only => [:show, :update]
  layout 'registered'
  
  def new
    @merge = Merge.new
    @virtual_merge = VirtualMerge.new
  end

  def create
    @identity = Identity.find_by_identity params[:identity]

    @merge = VirtualMerge.accounts current_user, @identity
    if @merge.save        
       redirect_to new_merge_path, :notice => I18n.t(:merge_instructions_sent)
    else
      #render :new
      redirect_to new_merge_path
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
