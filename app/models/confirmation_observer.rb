class ConfirmationObserver < ActiveRecord::Observer

  def after_save confirmation
    deliver_confirmation_message! confirmation    
  end

  private

    def deliver_confirmation_message! confirmation
      UserNotifier.confirmation(confirmation, confirmation.confirmable_klass_type.to_sym).deliver! unless confirmation.confirmed?
    end

end
