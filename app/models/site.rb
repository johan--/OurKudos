class Site < ActiveRecord::Base
  
  has_many :api_keys
  
  validates :protocol, :presence => true
  validates :url, :presence => true
  validates :site_name, :presence => true
  
  scope :blocked, where(:blocked => true)
  
  after_save :create_and_generate_first_api_key
  
  def create_and_generate_first_api_key
    self.api_keys.create if api_keys.count == 0
  end  
  
  def ban!
    update_attribute :blocked, true
  end
  
  def unban!
    update_attribute :blocked, false
  end
  
  def to_s
    "#{protocol}://#{url}"
  end
  
  
  class << self
    
    def  options_for_protocol
      [
        ['http','http'],
        ['https', 'https']
      ]
    end
    
  end
  
  
end
