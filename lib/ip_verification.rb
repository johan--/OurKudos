module OurKudos
  module Controllers
    module IpVerification
        
      def get_ip
         Ip.create_or_initialize_with request
      end

      def verify_ip
        @sign_in_ip = get_ip
        if @sign_in_ip.blocked? || @sign_in_ip.is_locked?
          if @sign_in_ip.is_locked?
            @sign_in_ip.session_is_invalid
          end
          redirect_to root_path, :alert => @sign_in_ip.lock_message
          false
        else
          true
        end
      end

      def ip_check
        @ip = get_ip
        @ip.is_locked? ?   @ip.session_is_invalid : @ip.session_is_valid
        !@ip.is_locked?
      end

      def ip_check_for resource, password, ok_method = :devise_sign_in
         case @sign_in_ip.check_for resource, password
           when :ok
             instance_eval ok_method.to_s
             clean_email_for_pass_recovery
           when :invalid, :not_expired
             save_email_for_pass_recovery
             redirect_to :back, :alert => @sign_in_ip.lock_message
         end
      end

      def save_email_for_pass_recovery
        session['user.email_for_password_recovery'] = params[:user][:email] if params[:user] && params[:user][:email] =~ RegularExpressions.email
      end

      def clean_email_for_pass_recovery
        session['user.email_for_password_recovery'] = nil
      end



    end
  end
end
