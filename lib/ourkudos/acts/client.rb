module OurKudos
  module Acts
    module Client

     def self.included(base)
       base.extend AddActsAsOurKudosClient
     end
     
     module AddActsAsOurKudosClient
          def acts_as_ourkudos_client(options = {:token => :authentication_token})
            
            cattr_reader :application_id, :application_secret, :ourkudos_host

            class_eval <<-RUBY
               include OurKudos::Acts::Client::InstanceMethods

               if defined?(Devise) && Devise.omniauth_configs[:ourkudos]
                  @@application_id, @@application_secret = Devise.omniauth_configs[:ourkudos].args[0..1]
                  @@ourkudos_host = Devise.omniauth_configs[:ourkudos].args[2][:site]
                else
                raise "Please put correct config in devise initializer i.e. config.omniauth :ourkduos 'app_id', 'app_secret'"
              end
           RUBY

          end
     end

     
     module InstanceMethods
     
       def client
         @client ||= OAuth2::Client.new self.application_id, self.application_secret, :site => self.ourkudos_host
       end

       def ourkudos
         @ourkudos ||= OAuth2::AccessToken.new(client, self.authentication_token)
       end


       module ClassMethods

     
         
       end

     end

   end
  end
end