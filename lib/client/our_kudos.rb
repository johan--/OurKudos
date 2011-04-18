require 'nestful'
require 'resource_editor'
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
    
    include OurKudos::ResourceEditor
    
    #configuration hash
    OurKudosClientOptions = { 'api_key' => nil, 
                              'base_uri' => "http://localhost:3000/api/" } if !Object.const_defined? :ClientOptions # :nodoc:

    
    #load settings from yaml file, if file is found
    if File.exists? OurKudos.config_file_path
      config = YAML.load_file OurKudos.config_file_path
      @@base_uri = OurKudosClientOptions['base_uri'] = config['base_uri']
      @@api_key  = OurKudosClientOptions['api_key']  = config['api_key']
    end
    
    # CLASS METHODS #
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
  
    # INSTANCE METHODS #
    
    #sets resource to read/edit/delete
    def resource_name= resource
      OurKudos::ResourceEditor.resource_name = resource
    end
    
    #displays current resource
    def resource_name 
      OurKudos::ResourceEditor.resource_name 
    end

      # general restuful post method - creates an item
      def post(options = {})
          Nestful.post OurKudos.base_uri + options[:path], :params => {:api_key => OurKudos.api_key}.merge(options[:params]), 
                                                                     :format => :json 
      end
      
      # retrieves item
      def get(options = {})
        Nestful.get OurKudos.base_uri + options[:path], :params => {:api_key => OurKudos.api_key}.merge(options[:params]), 
                                                                     :format => :json
      end          
      
      # updates item
      def put(options = {})
        Nestful.put OurKudos.base_uri + options[:path], :params => {:api_key => OurKudos.api_key}.merge(options[:params]), 
                                                                     :format => :json
      end          
      
      # deletes item
      def delete(options = {})
        Nestful.delete OurKudos.base_uri + options[:path], :params => {:api_key => OurKudos.api_key}.merge(options[:params]),   
                                                                           :format => :json
      end                                           
      
      
      
    
    
  end
end  