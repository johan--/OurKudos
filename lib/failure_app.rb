module Devise
  class FailureApp < ActionController::Metal # \m/ ROCKS :-)


    def i18n_message(default = nil)
      message = warden.message || warden_options[:message] || default || :unauthenticated
      #ugly hack override for twitter
      message = :inactive if message == :invalid_token && params[:action] == "twitter"

      if message.is_a?(Symbol) && message != :inactive
        message_without_link message
      elsif message.is_a?(Symbol) && message == :inactive
        message_with_link message
      else
        message.to_s
      end
    end

    def get_param
      return params[:user][:email] if params[:user] && params[:user][:email]
      return params[:user_id] if params[:user] && params[:user_id]

      email = env['omniauth.auth'].recursive_find_by_key("email")

      return email unless email.blank?
      env['omniauth.auth'].recursive_find_by_key("uid")
    end

    def message_without_link message
      I18n.t(:"#{scope}.#{message}", :resource_name    => scope,
                                              :scope   => "devise.failure",
                                              :default => [message, message.to_s])

    end

    def message_with_link message, type = "email"
      I18n.t(:"#{scope}.#{message}", :resource_name => scope,
                                            :host   => request.host,
                                            :param  => get_param,
                                            :type   => get_param_type,
                                            :scope  => "devise.failure",
                                            :default=> [message, message.to_s])
    end

    def get_param_type
       return "email"      if (!params[:user].blank?    && env['omniauth.auth'].blank? && !params[:user][:email].blank?) || params[:action] == "facebook"
       return "user_id"    if (!params[:user_id].blank? && env['omniauth.auth'].blank? && !params[:user].blank?)
       "uid"
    end

  end
end