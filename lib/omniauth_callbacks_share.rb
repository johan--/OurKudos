module OurKudos
  module OmniauthCallbacksShare

      def add_new_authentication
        return false if current_user.nil?

        if preexisting_authorization_token && preexisting_authorization_token.user != current_user
          flash[:alert] = "You have created two accounts and they can't be merged automatically. If you want to merge them please sign in, and use or merge account functionally"
          sign_in_and_redirect(:user, current_user)
          fetch_facebook_friends
        elsif preexisting_authorization_token && preexisting_authorization_token.user == current_user
          flash[:notice] = "Account connected"
          sign_in_and_redirect(:user, current_user)

        else
          current_user.apply_omniauth(omniauth_data)
          current_user.save :validate => false

          flash[:notice] = "Account connected"
          sign_in_and_redirect(:user, current_user)
          fetch_facebook_friends
        end
      end


  end
end