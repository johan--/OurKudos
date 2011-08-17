class PasswordChangesController < ApplicationController
  before_filter :authenticate_user!, :except => [:undo]

  layout "registered"

  def new
    @user = current_user
  end

  def create
    @user = current_user
    @user.remember_old_pass = true
    @user.has_company = true if @user.company_name
    if request.post?
      if @user.update_attributes params[:user]
        update_session_for_user
        sign_in :user, @user
        UserNotifier.password_changed(@user, params[:user][:password]).deliver! if params[:user]
        redirect_to home_path, :notice => I18n.t(:your_password_has_been_successfuly_changed)
      else
        render :new
      end
    end
  end

  def undo
    @user = User.find_by_old_password_salt params[:user_id]
    if @user && @user.undo_last_password_change!
      redirect_to root_path, :notice => I18n.t(:your_password_has_been_successfuly_restored)
    else
      redirect_to root_path, :alert => I18n.t(:your_password_has_not_been_successfuly_restored)
    end
  end

  private

    def update_session_for_user
      session['warden.user.user.key'] = current_user.class.name, [current_user.id], current_user.password_salt
    end

end
