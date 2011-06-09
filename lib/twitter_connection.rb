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


     def post_twitter_kudo kudo, user = nil
        begin
          result = twitter_user.update(kudo.body) if user.blank?
          result = twitter_user.direct_message_create(kudo.body, user) if user
          result.is_a?(Hashie::Rash)
          true
        rescue Errno, Exception => e
          Rails.logger.info "Failed to post twitter kudo #{e.to_s}"
          e.to_s
        end
     end




  end
end