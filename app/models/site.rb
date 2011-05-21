class Site < ActiveRecord::Base
  
  has_many :api_keys
  
  validates :protocol,  :presence => true
  validates :url,       :presence => true
  validates :site_name, :presence => true
  
  scope :blocked, where(:blocked => true)
  
  before_save :create_application_id_and_secret
  
  def create_application_id_and_secret
    self.application_id, self.application_secret = SecureRandom.hex(16), SecureRandom.hex(16)
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
  
  def keys
    api_keys.map(&:key)
  end


  
  
  class << self
    
    def  options_for_protocol
      [
        ['http','http'],
        ['https', 'https']
      ]
    end

    def authenticate app_id, app_secret
      where(:application_id => app_id, :application_secret => app_secret).first
    end

    
  end
  
  
end
