require 'omniauth/oauth'
require 'multi_json'

module OmniAuth
  module Strategies
    class Ourkudos < OAuth2

      include OmniAuth::Strategy
      def initialize(app, client_id = nil, client_secret = nil, options = {}, &block)      
        super app, :ourkudos, client_id, client_secret, {}, options, &block
      end

      def request_phase
        options[:response_type] ||= 'code'
        redirect options[:site] + client.web_server.authorize_url({:redirect_uri => callback_url}.merge(options))
      end

      def user_data
       @data ||= MultiJson.decode(@access_token.get(client.site + '/oauth/user', {'oauth_token' => @access_token.token}))
      end

      def user_info
        {
          'email'      => (user_data["email"] if user_data["email"]),
          'first_name' => user_data["first_name"],
          'last_name'  => user_data["last_name"],
          'name'       => "#{user_data['first_name']} #{user_data['last_name']}"
        }
      end

      def auth_hash
        OmniAuth::Utils.deep_merge(super, {
          'uid'       => user_data["user"]["id"],
          'user_info' => user_info,
          'extra'     => {'user_hash' => user_data}
        })
      end

    end
  end
end
