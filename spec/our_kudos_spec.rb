require 'spec_helper'

describe OurKudos::Client do
    context "#initialize" do
      it "returns OurKudos::Client instance" do
        instance = OurKudos::Client.new
        instance.should be_a(OurKudos::Client)
      end
      
      it 'should be able to assign an api key' do
        OurKudos::Client.respond_to? "api_key=" should_not be_false
      end
      
    end
    
    context "given an instance" do
      let(:client) { OurKudos::Client.new }

        it 'should be able to assign an api key' do
          client.api_key == 'new_api_key'
          client.api
        end

    end
    
  end
  

    