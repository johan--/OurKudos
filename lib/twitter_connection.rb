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

    def configure_twitter
      Twitter.configure do |config|
          config.consumer_key       = Devise.omniauth_configs[:twitter].args[0]
          config.consumer_secret    = Devise.omniauth_configs[:twitter].args[1]
          config.oauth_token        = twitter_auth.token
          config.oauth_token_secret = twitter_auth.secret
      end
    end

    def twitter_user
      configure_twitter
      @twitter_user ||= Twitter::Client.new
    end




  end
end