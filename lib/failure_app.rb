module Devise
  class FailureApp < ActionController::Metal # \m/ ROCKS :-)


    def i18n_message(default = nil)
      message = warden.message || warden_options[:message] || default || :unauthenticated
      #ugly hack override for twitter
      message = :inactive if message == :invalid_token && params[:action] == "twitter"

      if message.is_a?(Symbol)
        if  message == :timeout
          flash[:alert] = nil
        elsif message == :invalid
          send_failure_notice(params[:user][:email], request.remote_ip, request.user_agent)
          flash[:alert] = "Incorrect Username and/or Password"
        elsif message != :inactive && message != :unauthenticated
          message_without_link message
        elsif  message == :inactive
          message_without_link message
#message_with_link message
        elsif  message == :unauthenticated
          flash[:notice] = I18n.t('devise.failure.unauthenticated')
          flash[:notice] = I18n.t(:please_sign_in_with_email, :email => params[:recipient].to_s) if user_attempted_to_visit_inbox?
          flash[:alert]  = nil
         end
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
                                              :default => [message, message.to_s]).html_safe

    end

    def message_with_link message, type = "email"
      I18n.t(:"#{scope}.#{message}", :resource_name => scope,
                                            :host   => request.host,
                                            :param  => get_param,
                                            :type   => get_param_type,
                                            :scope  => "devise.failure",
                                            :default=> [message, message.to_s]).html_safe
    end

    #this is used to set resend link parameters when user tries to sign in but has not activeated account yet.
    def get_param_type
       return "email"      if (!params[:user].blank?    && env['omniauth.auth'].blank? && !params[:user][:email].blank?) || params[:action] == "facebook"
       return "user_id"    if (!params[:user_id].blank? && env['omniauth.auth'].blank? && !params[:user].blank?)
       "uid"
    end

    def user_attempted_to_visit_inbox?
      !params[:kudo_id].blank? &&
          !params["recipient"].blank? &&
              params["recipient"] =~ RegularExpressions.email
    end

    def redirect_url
      if user_attempted_to_visit_inbox?
        send(:"new_#{scope}_session_path", :user => {:email => params[:recipient]} )
      else
        if skip_format?
          send(:"new_#{scope}_session_path")
        else
          send(:"new_#{scope}_session_path", :format => request_format)
        end
       end
    end

    def skip_format?
      %w(html */*).include? request_format.to_s
    end

    def send_failure_notice(user, ip, user_agent)
      UserNotifier.login_failure_notify_admin("username", user, ip, user_agent).deliver
    end

  end
end
