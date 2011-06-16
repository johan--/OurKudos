require 'devise/strategies/authenticatable'

module Devise
  module Strategies

    class DatabaseAuthenticatableWithIdentities < Authenticatable
      def authenticate!
        resource = valid_password? && Identity.find_by_identity_and_identity_type(authentication_key.gsub(/^@{1}/,''), get_identity_type).user rescue nil

        if validate(resource){ resource.valid_password?(password) }
          resource.after_database_authentication
          success!(resource)
        elsif !halted?
          fail(:invalid)
        end
        session['user.email_for_password_recovery'] = authentication_hash[:email] if authentication_hash[:email] =~ RegularExpressions.email
      end

      def authentication_key
        authentication_hash[:email]
      end

      def get_identity_type
        return "email"   if authentication_key =~ RegularExpressions.email
        "twitter" if authentication_key =~ RegularExpressions.twitter
      end
    end
  end
end

Warden::Strategies.add(:database_authenticatable_with_identities,
                        Devise::Strategies::DatabaseAuthenticatableWithIdentities)