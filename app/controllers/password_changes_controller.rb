class PasswordChangesController < ApplicationController
  before_filter :authenticate_user!

  layout "registered"

  def new
    @user = current_user
  end

  def create
    @user = current_user
    if request.post?
      if @user.update_attributes params[:user]
        update_session_for_user
        sign_in(:user, @user)
        UserNotifier.password_changed(@user, params[:user][:password]).deliver! if params[:user]
        redirect_to home_path, :notice => I18n.t(:your_password_has_been_successfuly_changed)
      else
        render :new
      end
    end
  end

  private

    def update_session_for_user
      session['warden.user.user.key'] = current_user.class.name, [current_user.id], current_user.password_salt
    end

end
