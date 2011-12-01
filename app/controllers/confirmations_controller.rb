class ConfirmationsController < ApplicationController


  def show
    confirmation = Confirmation.find_by_key params[:id]
    confirmation.confirm!
    if confirmation.confirmed?
      sign_in :user, confirmation.confirmable.merger if merge_confirmation?
      sign_in :user, confirmation.confirmable.merger if virtual_merge_confirmation?
      sign_in :user, confirmation.confirmable.user   if account_confirmation?

      redirect_to current_confirm_redirect_path(confirmation), :notice => I18n.t(:resource_confirmed, :resource => set_resource(confirmation.confirmable_klass_type))
    else
      redirect_to root_path, :alert => I18n.t(:unable_to_confirm_resource, :resource => set_resource(confirmation.confirmable_klass_type))
    end
  end


    def resend
      set_user
      process_it
    end

  private

    def current_confirm_redirect_path(confirmation)
      case confirmation.confirmable_klass_type.to_sym
        when :identity
          return '/home' if confirmation.confirmable.user.identities.length == 1
          return user_path(confirmation.confirmable.user)
        when :merge
          merge_path(confirmation.confirmable)
        when :virtual_merge
          virtual_merge_path(confirmation.confirmable)
      end
    end

    def merge_confirmation?
      params[:merge] == "true" 
    end

    def virtual_merge_confirmation?
      params[:virtual_merge] == "true" 
    end

    def account_confirmation?
      params[:account] == "true"
    end

    def set_user
      case params[:type]
        when "email"
          @user = User.find_by_email params[:param]
        when 'uid'
          @user = Authentication.find_by_uid(params[:param]).user rescue nil
        when "user_id"
          @user = User.find params[:param]
        else
          redirect_to root_path, :alert => I18n.t('devise.failure.use_valid_link')
        end
    end

    def process_it
      if @user
        confirmation = @user.primary_identity.confirmation

        if confirmation.blank?
          redirect_to root_path, :alert => I18n.t('devise.failure.could_not_find_such_user')
        else
        confirmation.resend!
          redirect_to root_path, :notice => I18n.t('devise.failure.email_sent')
        end
      else
        redirect_to root_path, :alert => I18n.t('devise.failure.could_not_find_such_user')
      end
    end

    def set_resource resource
      return resource unless resource == 'virtual_merge'
      'merge'
    end


end
