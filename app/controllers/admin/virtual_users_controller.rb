class Admin::VirtualUsersController < Admin::AdminController
  before_filter :authenticate_user!
  load_and_authorize_resource
  respond_to :html, :js
  helper_method :sort_column, :sort_direction
  
  
  def index
    @users = VirtualUser.page(params[:page]).per(params[:per_page]) 
    #@users = @users.search params[:search] unless params[:search].blank?
    #@users = @users.order "#{sort_column} #{sort_direction}"
  end

  def update
    @user = VirtualUser.find params[:id]
    @user.skip_password_validation = true
    if @user && @user.update_attributes(params[:user])
      redirect_to admin_users_path, :notice => I18n.t(:user_data_updated_successfully)
    else
      redirect_to admin_user_path(@user), :alert => @user.errors.full_messages.join(", ")
    end
  end
  
  def show  
    @user = VirtualUser.find params[:id]
  end
  
  def destroy
    @user = VirtualUser.find params[:id]
    if @user && @user.authentications.destroy_all && @user.destroy
      redirect_to admin_users_path, :notice => I18n.t(:user_removed_successfully)
    else
      redirect_to admin_users_path, :notice => I18n.t(:user_not_removed_successfully)
    end
  end
  
  
  private 
  
    def sort_column
      VirtualUser.column_names.include?(params[:column]) ? (return params[:column]) : (return "email")
    end
    
    def sort_direction
      %{asc desc}.include?(params[:direction].to_s) ? (return params[:direction]) : (return "asc")
    end


  
end
