class ApiKey < ActiveRecord::Base
  
  belongs_to :site
  
  before_save :generate
  
  def generate key_length = 64
    return self.key unless self.key.blank?
     
    big_array = ('A'..'Z').to_a + ("a".."z").to_a + ("0".."9").to_a
    self.key = ''
    1.upto(key_length) { self.key << big_array[rand(big_array.size-1)] }
  end
  
  def regenerate!
    self.key = ''
    generate
    save :validate => false
  end
  
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
