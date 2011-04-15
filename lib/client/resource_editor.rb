module OurKudos
  module ResourceEditor
      
      def self.resource_name= name
        @@resource_name = name
      end
      
      def self.resource_name
        @@resource_name
      end
      
      def create fields = {}
        post(:path => "#{@@resource_name}s.json",  :params =>  {:user => fields})
      end
      
      def edit(id, fields = {})
        put(:path => "#{@@resource_name}s/#{id.to_s}.json", :params => {:user => fields })
      end
      
      def show id
        get(:path => "#{@@resource_name}s/#{id.to_s}.json", :params => {})
      end
    
    
  end
end