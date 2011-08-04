class Admin::KudoFlagActionsController < Admin::AdminController
  
  def create
    @action = KudoFlagAction.new params[:kudo_flag_action]
    if @action.save
      flash[:notice] = "Success"
      redirect_to admin_kudo_flag_action_url
    else
      flash[:error] = "Failure"
      #redirect_to admin_kudo_flags_url
      redirect_to root_url#admin_kudo_flags_url
    end
  end

end
