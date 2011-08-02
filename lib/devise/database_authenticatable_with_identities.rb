require 'devise/strategies/authenticatable'

module Devise
  module Strategies

    class DatabaseAuthenticatableWithIdentities < Authenticatable

      attr_reader :identity

      def authenticate!
        if (identity = Identity.find_for_authentication(authentication_key)).blank?
          fail(:invalid)
        else
          resource = valid_password? && identity.user rescue nil

          if validate(resource){ resource.valid_password?(password) && !resource.is_banned? }
            resource.after_database_authentication
            success!(resource)
          elsif !halted?
            save_email_for_pass_recovery
            fail(:invalid)
          end
        end

      end

      def authentication_key
        authentication_hash[:email]
      end

      def save_email_for_pass_recovery
        session['user.email_for_password_recovery'] = authentication_hash[:email] if authentication_hash[:email] =~ RegularExpressions.email
      end


    end
  end
end

Warden::Strategies.add(:database_authenticatable_with_identities,
                        Devise::Strategies::DatabaseAuthenticatableWithIdentities)