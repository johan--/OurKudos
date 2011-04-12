class ApiKey < ActiveRecord::Base
  
  belongs_to :site
  
  def generate key_length = 64
    return self.api_key unless self.api_key.blank?
     
    big_array = ('A'..'Z').to_a + ("a".."z").to_a + ("0".."9").to_a
    self.api_key = ''
    1.upto(key_length) { self.api_key << big_array[rand(big_array.size-1)] }
  end
  
  def regenrate!
    self.api_key = ''
    generate
    save :validate => false
  end
  
  
end
