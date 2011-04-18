class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :token_authenticatable, :confirmable, :locakble, :timeoutable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name
  
  has_many :authentications

  
  
  
  

  
end
