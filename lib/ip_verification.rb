module OurKudos
  module Controllers
    module IpVerification
        
      def get_ip
         Ip.create_or_initialize_with request
      end

      def verify_ip
        @sign_in_ip = get_ip
        if @sign_in_ip.blocked? || @sign_in_ip.is_locked?
          @sign_in_ip.session_is_invalid if @sign_in_ip.is_locked?
          redirect_to root_url, :notice => @sign_in_ip.lock_message
          false
        else
          true
        end
      end

      def ip_check
        @ip = get_ip
        @ip.is_locked? ?   @ip.session_is_invalid : @ip.session_is_valid
        return !@ip.is_locked?
      end

      def ip_check_for resource, password, ok_method = :devise_sign_in
        result = @sign_in_ip.check_for resource, password
         case result
            when :ok                    ; instance_eval ok_method.to_s
            when :invalid, :not_expired ; redirect_to :back, :notice => @sign_in_ip.lock_message
         end
      end



    end
  end
end
