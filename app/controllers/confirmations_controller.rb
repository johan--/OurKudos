class ConfirmationsController < ApplicationController

  def show
    confirmation = Confirmation.find_by_key params[:id]
    confirmation.confirm!

    if confirmation.confirmed?
      sign_in :user, confirmation.confirmable.merger if merge_confirmation?
      sign_in :user, confirmation.confirmable.user   if account_confirmation?

      redirect_to current_confirm_redirect_path(confirmation), :notice => I18n.t(:resource_confirmed, :resource => confirmation.confirmable_klass_type)
    else
      redirect_to root_path, :alert => I18n.t(:unable_to_confirm_resource, :resource => confirmation.confirmable_klass_type)
    end
  end

  private

    def current_confirm_redirect_path(confirmation)
      case confirmation.confirmable_klass_type.to_sym
        when :identity
          return root_path if confirmation.confirmable.user.identities.length == 1
          return user_path(confirmation.confirmable.user)
        when :merge
          merge_path(confirmation.confirmable)
      end
    end

    def merge_confirmation?
      params[:merge] == "true" 
    end

    def account_confirmation?
      params[:account] == "true"
    end


end
