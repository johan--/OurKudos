class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  
  def method_missing provider
    debug(session[:omniauth])
    if !User.omniauth_providers.index(provider).blank?

      omniauth = env["omniauth.auth"]
    
      if current_user
        current_user.authentications.find_or_create_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
         flash[:notice] = "Authentication successful"
         redirect_to edit_user_registration_path
      else
    
      authentication = Authentication.find_by_provider_and_uid omniauth['provider'], omniauth['uid']
   
        if authentication
          flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => omniauth['provider']
          #sign_in_and_redirect :user, authentication.user
          sign_in_and_redirect authentication.user, :event => :authentication
        else
          
          unless omniauth.recursive_find_by_key("email").blank?
            user = User.find_or_initialize_by_email :email => omniauth.recursive_find_by_key("email")
          else
            user = User.new
          end
          
          user.apply_omniauth(omniauth)
       
          user.confirm! unless user.email.blank?

          if user.save 
            flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => omniauth['provider'] 
            sign_in_and_redirect(:user, user)
          else
            session[:omniauth] = omniauth.except('extra')
            flash[:notice] = I18n.t 'devise.oauth.information.missing'
            redirect_to new_user_registration_path(:autofill => "true")
          end
          
        end
      end
    end
  end
  
end