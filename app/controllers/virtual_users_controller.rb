class VirtualUsersController < ApplicationController
  before_filter :authenticate_user!, :except => [:show]
  layout :choose_layout
  
  def show
    @virtual_user = VirtualUser.find params[:id]
    @kudos = @virtual_user.send("received_kudos")
    @kudos.sort! { |a,b| b.updated_at <=> a.updated_at }
  end

  def update
    @virtual_user = VirtualUser.find params[:id]
    if @virtual_user.update_attributes(params[:virtual_user])
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
