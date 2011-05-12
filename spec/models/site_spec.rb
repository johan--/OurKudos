require 'spec_helper'

describe Site do
  
  it 'should be able to display blocked sites' do
    Site.should respond_to "blocked"
    Site.blocked.should be_an_instance_of ActiveRecord::Relation
  end

  it 'should be able to get all protocol types' do
    Site.should respond_to 'options_for_protocol'
    Site.options_for_protocol.should be_an_instance_of Array
    Site.options_for_protocol.first.should be_an_instance_of Array
    Site.options_for_protocol.size.should == 2
  end


  
  context 'given an instance' do 
    let(:site) { Site.new(:protocol => 'http', :url => "onet.pl", :site_name => "my site") }
  
    it 'should be able to create and generate first api key, right after saved' do
      site.should respond_to 'create_and_generate_first_api_key'
      site.api_keys.should be_blank
      site.save :validate => false
      site.api_keys should_not be_blank
    end
    
    it 'should be able to mark given site as blcoked/banned' do
      site.should respond_to 'ban!'
      site.blocked.should be_false
      site.ban!
      site.blocked.should be_true
    end
    
    it 'should be able to unban/unlock given site' do
      site.ban!
      site.should respond_to 'unban!'
      site.unban!
      site.blocked.should be_false
    end

    it 'should be able to display full url with protocol' do
      site.to_s.include?(site.protocol).should be_true
      site.to_s.include?(site.url).should be_true
    end

    it 'should be able to display all related keys' do
      site.should respond_to 'keys'
      site.save
      site.keys.should be_an_instance_of Array
      site.keys.first.should be_an_instance_of String
      site.keys.first.size.should == 64
    end
    
  
  end
  
end
