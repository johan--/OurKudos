require 'devise/strategies/authenticatable'

module Devise
  module Strategies

    class DatabaseAuthenticatableWithIdentities < Authenticatable

      attr_reader :identity

      def authenticate!
        @identity = Identity.find_by_identity_and_identity_type(authentication_key.gsub(/^@{1}/,''), get_identity_type)

        if identity_is_invalid?
          save_email_for_pass_recovery
          fail(:invalid)
        else

          resource = valid_password? && identity.user rescue nil

          if validate(resource){ resource.valid_password?(password) }
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

      def get_identity_type
        return "email"   if authentication_key =~ RegularExpressions.email
        "twitter" if authentication_key =~ RegularExpressions.twitter
      end

      def save_email_for_pass_recovery
        session['user.email_for_password_recovery'] = authentication_hash[:email] if authentication_hash[:email] =~ RegularExpressions.email
      end

      def identity_is_invalid?
        @identity.blank? || (@identity && !@identity.confirmation.confirmed?)
      end


    end
  end
end

Warden::Strategies.add(:database_authenticatable_with_identities,
                        Devise::Strategies::DatabaseAuthenticatableWithIdentities)