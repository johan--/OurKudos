class UsersController < ApplicationController
  before_filter :authenticate_user!
  layout 'registered'
  
  def show
    @user            = current_user
    @user
    @authentications = current_user.authentications
    @identities      = current_user.identities.order('identity_type asc')
    @kudos           = current_user.inbox.kudos.page(params[:page]).per(5)
  end
  
  def edit
    @user = User.find(current_user.id)
  end
  
  def update
    @user = current_user
    @user.skip_password_validation = true
    @user.has_company = true if @user.company_name
    if @user.update_attributes(params[:user])
      redirect_to @user, :notice  => "Successfully updated user."
    else
      render :action => 'edit'
    end
  end
  
end
