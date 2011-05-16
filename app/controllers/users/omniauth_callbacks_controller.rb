class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_filter :set_omniauth_data
  
  attr_accessor :omniauth_data
  attr_accessor :preexisting_authorization_token
  
  def method_missing(provider)
    return super unless valid_provider?(provider)
    if provider == :twitter                    
      add_new_authentication || omniauth_sign_in || (redirect_to root_path, :notice => I18n.t('devise.omniauth_callbacks.twitter.sign_in'))
    else
      add_new_authentication || omniauth_sign_in || omniauth_sign_up
    end
  end

  def omniauth_sign_in
    return false unless preexisting_authorization_token

    flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => omniauth_data['provider']
    sign_in_and_redirect(:user, preexisting_authorization_token.user)
    true
  end

  def omniauth_sign_up
    email = omniauth_data.recursive_find_by_key("email")

    unless email.blank?
      user = User.find_by_email email            
      check_confirmation_and_redirect(user) and return if user
      
      identity = Identity.find_by_identity_and_identity_type(email, 'email')
      check_confirmation_and_redirect identity.user and return if identity        

      user = User.new
    else
      user = User.new
    end
    user.apply_omniauth omniauth_data
    
    session[:user] = user.attributes
    session[:authentication] = user.authentications.first.attributes

    if user.save 
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => omniauth_data['provider'] 
      redirect_to new_user_registration_path(:autofill => "true")
    else
      flash[:notice] = I18n.t 'devise.oauth.information.missing'
      redirect_to new_user_registration_path(:autofill => "true")
    end
  end

  def add_new_authentication
    return false if current_user.nil?

    if preexisting_authorization_token && preexisting_authorization_token.user != current_user
      flash[:alert] = "You have created two accounts and they can't be merged automatically. If you want to merge them please sign in, and use or merge account functionally"
      sign_in_and_redirect(:user, current_user)
    else

      current_user.apply_omniauth(omniauth_data)      
      current_user.save :validate => false
      
      flash[:notice] = "Account connected"
      sign_in_and_redirect(:user, current_user) 
    end
  end

  def set_omniauth_data
    self.omniauth_data = env["omniauth.auth"]
    self.preexisting_authorization_token = Authentication.find_by_provider_and_uid(omniauth_data['provider'], omniauth_data['uid'])
  end

  def valid_provider?(provider)
    !User.omniauth_providers.index(provider).nil?
  end

  def check_confirmation_and_redirect user
    unless user.is_confirmed?
      flash[:notice] = I18n.t('devise.regristrations.inactive_signed_up')
      sign_out_and_redirect user
    else
      flash[:notice] = "Account connected"
      sign_in :user, user
      add_new_authentication 
     end
  end
  
end