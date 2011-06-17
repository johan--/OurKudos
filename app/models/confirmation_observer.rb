class ConfirmationObserver < ActiveRecord::Observer

  def after_save confirmation
    deliver_confirmation_message! confirmation
    save_invitations_in_inbox confirmation
  end

  private

    def deliver_confirmation_message! confirmation
      UserNotifier.delay.confirmation(confirmation, confirmation.confirmable_klass_type.to_sym) unless confirmation.confirmed?
    end

    def save_invitations_in_inbox confirmation
      confirmable = confirmation.confirmable
    end

end
