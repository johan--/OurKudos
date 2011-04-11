require 'rest-client'
require 'json'
module OurKudos
  
  class << self
    
    #alias method
    def api_key 
      OurKudos::Client.api_key
    end
    
    #alias methods
    def base_uri
      OurKudos::Client.base_uri
    end
    
    #alias method
    def api_key= api_key
      OurKudos::Client.api_key = api_key
    end
    
    #alias method
    def base_uri= uri
      OurKudos::Client.base_uri = uri
    end
    
    def config_file_path
      File.join File.expand_path(File.dirname(__FILE__)), 'config', 'config.yaml'
    end
    
  end
  
  
  
  class Client
    
    cattr_accessor :api_key, :base_uri
    
    #configuration hash
    OurKudosClientOptions = { 'api_key' => nil, 
                              'base_uri' => "http://localhost:3000/api/" } if !Object.const_defined? :ClientOptions # :nodoc:

    
    #load settings from yaml file, if file is found
    if File.exists? OurKudos.config_file_path
      config = YAML.load_file OurKudos.config_file_path
      @@base_uri = OurKudosClientOptions['base_uri'] = config['base_uri']
      @@api_key  = OurKudosClientOptions['api_key']  = config['api_key']
    end
    
    class << self
      
      #sets new api key
      def api_key= api_key = nil
        return @@api_key unless api_key
            
        @@api_key  = OurKudosClientOptions['api_key'] = api_key
      end
      
      #sets base url
      def base_uri= base_uri = nil
        return @@base_uri unless base_uri
        
        @@base_uri = OurKudosClientOptions['base_uri'] = base_uri
      end
      
    end
  
    
    
    
    def create_account username, password, password_confirmation
      RestClient.post 
      
    end
    
  end
end  