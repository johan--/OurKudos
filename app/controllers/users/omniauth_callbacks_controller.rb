class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_filter :set_omniauth_data
  
  attr_accessor :omniauth_data
  attr_accessor :preexisting_authorization_token
  
  def method_missing(provider)
    return super unless valid_provider?(provider)
    omniauthorize_additional_account || omniauth_sign_in || omniauth_sign_up
  end

  def omniauth_sign_in
    return false unless preexisting_authorization_token

    flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => omniauth_data['provider']
    sign_in_and_redirect(:user, preexisting_authorization_token.user)
    true
  end

  def omniauth_sign_up
    unless omniauth_data.recursive_find_by_key("email").blank?
      user = User.find_or_initialize_by_email(:email => omniauth_data.recursive_find_by_key("email"))
    else
      user = User.new
    end

    user.apply_omniauth(omniauth_data)

    if user.save 
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => omniauth_data['provider'] 
      sign_in_and_redirect(:user, user)
    else
      session[:user] = user.attributes
      session[:authentication] = user.authentications.first.attributes
      flash[:notice] = I18n.t 'devise.oauth.information.missing'
      redirect_to new_user_registration_path(:autofill => "true")
    end
  end

  def omniauthorize_additional_account
    return false if current_user.nil?
    if preexisting_authorization_token && preexisting_authorization_token != current_user
      flash[:alert] = "You have created two accounts and they can't be merged automatically. Email support@ourkudos.com for help."
      sign_in_and_redirect(:user, current_user)
    else

      current_user.apply_omniauth(omniauth_data)
      current_user.save

      flash[:notice] = "Account connected"
      sign_in_and_redirect(:user, current_user)
    end
  end

  def set_omniauth_data
    self.omniauth_data = env["omniauth.auth"]
    ActiveRecord::Base.logger.info(pp omniauth_data)
    self.preexisting_authorization_token = Authentication.find_by_provider_and_uid(omniauth_data['provider'], omniauth_data['uid'])
  end

  def valid_provider?(provider)
    !User.omniauth_providers.index(provider).nil?
  end
  
end