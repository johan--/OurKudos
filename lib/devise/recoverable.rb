module Devise
  module Models
    module Recoverable

      extend ActiveSupport::Concern

        def send_reset_password_instructions identity = false
          generate_reset_password_token! if should_generate_token?
          Devise::IdentityMailer.reset_password_instructions(self).deliver if identity.blank?
          Devise::IdentityMailer.reset_password_instructions(self, identity).deliver if identity
        end

        def should_generate_token?
          reset_password_token.nil? || !reset_password_period_valid?
        end

        def reset_password_period_valid?
          return true unless respond_to?(:reset_password_sent_at)
          reset_password_sent_at && reset_password_sent_at.utc >= self.class.reset_password_within.ago
        end



    end
  end
end