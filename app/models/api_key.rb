require 'token_generator'
class ApiKey < ActiveRecord::Base
  
  belongs_to :site
  
  before_save :generate
 
  def set_as_expired!
    update_attribute :expires_at, Date.today-100.years
  end
  
  def expired?
    return false if self.expires_at.blank?
    
    self.expires_at < Date.today
  end
  
  def set_as_valid!
    update_attribute :expires_at, nil
  end
  
  
end
