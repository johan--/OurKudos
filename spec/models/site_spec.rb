require 'spec_helper'

describe Site do
  
  it 'should be able to display blocked sites' do
    Site.should.resopnd_to "blocked"
    Site.blocked.should be_an_instance_of ActiveRecord::Relation
    
  end
  
  
end
