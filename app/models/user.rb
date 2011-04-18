class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :token_authenticatable, :confirmable, :locakble, :timeoutable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name
  
  has_many :authentications


  #TODO define more indexes as needed
  index do
    email
    first_name
    last_name
    middle_name
  end
  

  
  def to_s
    "#{first_name} #{middle_name} #{last_name}"
  end
  
  def self.search search
    return scoped if search.blank?
    where(:email => search)
  end
  
  
  

  
end
