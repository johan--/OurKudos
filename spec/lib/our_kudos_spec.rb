require 'spec_helper'

describe OurKudos::Client do
    context "#initialize" do
      
      it "returns OurKudos::Client instance" do
        instance = OurKudos::Client.new
        instance.should be_a(OurKudos::Client)
      end
      
      it 'should be able to assign an api key' do
        key = 'new_api_key'
        OurKudos::Client.respond_to?("api_key=").should_not be_false
        OurKudos::Client.api_key = key 
        OurKudos::Client.api_key.should == key && OurKudos.api_key == key
      end
      
      it 'should be able to assign base_url ' do
        uri = 'http://our-kudos.com/api'
        OurKudos::Client.respond_to?("base_uri=").should_not be_false
        OurKudos::Client.base_uri = uri
        OurKudos::Client.base_uri.should == uri && OurKudos.base_uri == uri
      end  
      
      it 'should be able to get config file path' do
        OurKudos.config_file_path.should_not be_nil 
      end
      
    end
    
    context "given an instance" do
      let(:client) { OurKudos::Client.new }
      
      it 'should be able to send create an account' do
        client.respond_to?("create_account").should_not be_nil
        
      end

    end
    
  end
  

    