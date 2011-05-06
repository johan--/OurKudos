class Admin::RolesController < ApplicationController

  respond_to :html

  before_filter :authenticate_user!
  before_filter :find_user, :only => [:edit]

  def index
    @roles = Role.all # we have only few roles so it's safe to call 'all'
    @role  = Role.new
  end
  
  def create
    @roles = Role.all
    @role = Role.new params[:role]
    if @role.save
      flash[:notice] = I18n.t(:role_has_been_created)
      respond_with @role, :location => admin_roles_path
    else
      render :index
    end
  end

  def edit
    @roles = Role.all
    @user  = User.find params[:id]
  end

  def destroy
    @role = Role.find params[:id]
    if @role.destroy
      redirect_to(:back, :notice => I18n.t(:role_has_been_deleted))
    else
      redirect_to(:back, :notice => I18n.t(:role_has_not_been_deleted))
    end
  end

  private


  def find_user
    @user = User.find params[:id]
  end

end
