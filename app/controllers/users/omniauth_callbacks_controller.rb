class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_filter :ip_check, :set_omniauth_data
  
  attr_accessor :omniauth_data
  attr_accessor :preexisting_authorization_token

  def method_missing provider
    if @ip.is_locked?
      redirect_to root_path, :notice => @ip.lock_message
    else
      return super unless valid_provider? provider
      if provider == :twitter
        add_new_authentication || omniauth_sign_in || (redirect_to root_path, :notice => I18n.t('devise.omniauth_callbacks.twitter.sign_in'))
      else
        add_new_authentication || omniauth_sign_in || omniauth_sign_up
      end
    end
  end

  def omniauth_sign_in
    return false unless preexisting_authorization_token

    flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => omniauth_data['provider']
    sign_in_and_redirect(:user, preexisting_authorization_token.user) and return
    true
  end

  def omniauth_sign_up
    email = omniauth_data.recursive_find_by_key("email")

    unless email.blank?
      user = User.find_or_initialize_by_email(:email => email)
     
      if user.new_record?
        identity = Identity.find_by_identity_and_identity_type(email, 'email')
        user     = identity.user if identity
      end

    else
      user = User.new
    end    
    user.apply_omniauth omniauth_data 
    
    session[:user] = user.attributes
    session[:authentication] = user.authentications.first.attributes
    
    if user.save
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => omniauth_data['provider']
      fetch_facebook_friends user if user
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

  private

  def set_omniauth_data
    self.omniauth_data = env["omniauth.auth"]
    self.preexisting_authorization_token = Authentication.find_by_provider_and_uid(omniauth_data['provider'], omniauth_data['uid']) if omniauth_data
  end

  def valid_provider?(provider)
    !User.omniauth_providers.index(provider).nil?
  end

  def fetch_facebook_friends(user = current_user)
    FacebookFriend.fetch_for(user) if omniauth_data['provider'] == "facebook" && user.facebook_friends.blank?
  end



end