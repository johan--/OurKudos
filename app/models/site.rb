class Site < ActiveRecord::Base
  
  has_many :api_keys
  
  validates :protocol, :presence => true
  validates :url, :presence => true
  validates :site_name, :presence => true
  
  class << self
    
  def  options_for_protocol
    [
      ['http','http'],
      ['https', 'https']
    ]
  end
    
  end
  
  
end
