module OurKudos
  module TwitterConnection

    def connected_with_twitter?
       !twitter_auth.blank?
    end

    def twitter_auth
      @twitter_auth ||= self.authentications.find_by_provider 'twitter'
    end

    def twitter_handles
      @twitter_handles ||= authentications.select {|a| a.provider == 'twitter'}.map(&:nickname).compact
    end

    def has_twitter_handle?(nickname)
     twitter_handles.any? { |handle| handle == nickname.gsub(/^@{1,}/, '') }
    end

    def twitter_user
      return if twitter_auth.blank?

       @twitter_user ||= Twitter::Client.new(
            :consumer_key       => Devise.omniauth_configs[:twitter].args[0],
            :consumer_secret    => Devise.omniauth_configs[:twitter].args[1],
            :oauth_token        => twitter_auth.token,
            :oauth_token_secret => twitter_auth.secret)
    end


     def post_twitter_kudo message
        begin
          #result = twitter_user.update message
          result.is_a?(Hashie::Rash)
          true
        rescue Errno, Exception => e
          Rails.logger.info "SOCIAL_POSTING: Failed to post twitter kudo #{e.to_s}"
          e.to_s
        end
     end


    def direct_message_to user, kudo
      begin
        #twitter_user.direct_message_create user, kudo.body
        true
       rescue Errno, Exception => e
          Rails.logger.info "SOCIAL_POSTING: Failed to post twitter direct message #{e.to_s}"
          e.to_s
        end
    end

    def get_user_info handle
      begin
        twitter_user = Twitter.user(handle)
        user = Hash.new
        unless twitter_user.protected? || twitter_user.blank?
          name = twitter_user.name.split(" ")
          user[:first_name] = name.first
          name.shift
          user[:last_name] = name.join(" ")
        end
        user
      rescue 
        nil
      end
    end

  end
end
