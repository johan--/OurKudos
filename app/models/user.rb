class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :token_authenticatable, :confirmable, :locakble, :timeoutable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :username
  
  has_many :authentications
  
  before_save :generate_api_key
  
  
  
  
  def generate_api_key key_length = 64
    return self.api_key unless self.api_key.blank?
     
    big_array = ('A'..'Z').to_a + ("a".."z").to_a + ("0".."9").to_a
    self.api_key = ''
    1.upto(key_length) { self.api_key << big_array[rand(big_array.size-1)] }
  end
  
  
end
