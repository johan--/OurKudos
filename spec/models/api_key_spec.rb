require 'spec_helper'

describe ApiKey do
  
  context 'given an instance' do 
    let(:api_key) { ApiKey.new(:site_id => 1) } 
    
    it 'should be able to generate an string key before save' do 
      new_api_key = ApiKey.new
      new_api_key.key.should be_blank
      new_api_key.save
      new_api_key.key.should_not be_blank
    end
    
    it 'should be able to re-generate given api string' do
      api_key.should respond_to 'regenerate!'
      api_key.save
      
      old_key = api_key.key
      
      api_key.regenerate!
      
      api_key.key.should_not == old_key
      
    end
    
    it 'should be able to set given api key as expired' do
      api_key.should respond_to 'set_as_expired!'
      api_key.should respond_to 'expired?'
      
      api_key.expires_at.should be_nil
      
      api_key.set_as_expired!
      
      api_key.expires_at.should_not be_nil
      api_key.expired?.should be_true
      
    end
    
    it 'should be able to mark given api key as valid if it is expired' do 
      api_key.should respond_to 'set_as_valid!'
      
      api_key.expires_at.should be_nil
      
      api_key.expired?.should be_false
      
    end
    
    
    
    
    
    
  end
  
  
end
