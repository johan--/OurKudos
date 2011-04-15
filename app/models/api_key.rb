class ApiKey < ActiveRecord::Base
  
  belongs_to :site
  
  before_save :generate
  
  def generate key_length = 64
    return self.key unless self.key.blank?
     
    big_array = ('A'..'Z').to_a + ("a".."z").to_a + ("0".."9").to_a
    self.key = ''
    1.upto(key_length) { self.key << big_array[rand(big_array.size-1)] }
  end
  
  def regenrate!
    self.key = ''
    generate
    save :validate => false
  end
  
  
end
