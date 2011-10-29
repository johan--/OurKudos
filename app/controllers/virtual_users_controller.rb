class VirtualUsersController < ApplicationController
  before_filter :authenticate_user!
  layout 'registered'
  
  def update
    @virtual_user = VirtualUser.find params[:id]
    if @virtual_user.check_and_process_merge(params[:virtual_user])
      redirect_to root_url, :notice  => "Thank You"
    else
      #need to resend the form
      #render :action => 'edit'
      redirect_to root_url
    end
  end

  def update_virtual_users
    if VirtualUser.update_from_member params[:virtual_users]
      redirect_to root_url, :notice  => "Thank You"
    else
      redirect_to root_url
    end
  end
  
end
