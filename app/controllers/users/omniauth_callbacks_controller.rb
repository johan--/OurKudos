class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_filter :ip_check, :set_omniauth_data
  
  attr_accessor :omniauth_data
  attr_accessor :preexisting_authorization_token

  layout :choose_layout

  def method_missing provider
    if @ip.is_locked?
      redirect_to root_path, :notice => @ip.lock_message
    else
      return super unless valid_provider? provider
      if provider == :twitter
        add_new_authentication || omniauth_sign_in || (redirect_to home_path, :notice => I18n.t('devise.omniauth_callbacks.twitter.sign_in'))
      else
        add_new_authentication || omniauth_sign_in || omniauth_sign_up
      end
    end
  end

  def omniauth_sign_in
    return false unless preexisting_authorization_token

    flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => omniauth_data['provider']
    sign_in_and_redirect(:user, preexisting_authorization_token.user)
    true
  end

  def omniauth_sign_up
     process_redirections_or_sign_up_for user_from_omniauth_or_identities
  end

  def add_new_authentication
    return false if current_user.nil?

    if preexisting_authorization_token && preexisting_authorization_token.user != current_user
      flash[:alert] = "You have created two accounts and they can't be merged automatically. If you want to merge them please sign in, and use or merge account functionally"
      fetch_facebook_friends
      sign_in_and_redirect(:user, current_user)
    elsif preexisting_authorization_token && preexisting_authorization_token.user == current_user
      flash[:notice] = "Account connected"
      sign_in_and_redirect(:user, current_user)

    else
      current_user.apply_omniauth(omniauth_data)
      current_user.save :validate => false

      fetch_facebook_friends
      flash[:notice] = "Account connected"
      sign_in_and_redirect(:user, current_user)
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
    FacebookFriend.fetch_for(user) if current_provider == "facebook" && user.facebook_friends.blank?
  end

  def current_provider
    omniauth_data['provider'] if omniauth_data
  end

  def user_from_omniauth_or_identities
     email = omniauth_data.recursive_find_by_key("email")
    unless email.blank?
      identity = Identity.find_for_authentication(email)
      user     = identity.user rescue nil
      user     = User.new if user.blank?
      user.apply_omniauth omniauth_data, !user.blank?
      user
    else
       User.new
    end
  end

  def process_redirections_or_sign_up_for user
    if user.new_record?
      session[:user]           = user.attributes
      session[:authentication] = user.authentications.first.attributes
      if user.save
        fetch_facebook_friends user if user
        redirect_to new_user_registration_path(:autofill => "true"), :notice => I18n.t("devise.omniauth_callbacks.success",  :kind => current_provider)
      else
        redirect_to new_user_registration_path(:autofill => "true"), :notice => I18n.t('devise.oauth.information.missing')
      end
    else
      user.save || user.authentications.last.save
      sign_in(:user, user)
      redirect_to '/home', :notice => I18n.t("devise.omniauth_callbacks.success", :kind => current_provider)
      fetch_facebook_friends user if user
    end
  end



end