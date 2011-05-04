class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :token_authenticatable, :confirmable, :lockable, :timeoutable, 
         :omniauthable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name,
                  :streetadress, :city, :state_or_province, :postal_code, :phone_number, :mobile_number, 
                  :gender
                  
  
  has_many :authentications
  
  validates :first_name, :presence => true
  validates :last_name, :presence => true

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
  
  def apply_omniauth omniauth
    unless omniauth['credentials'].blank?
      authentications.build(:provider => omniauth['provider'], 
                            :uid      => omniauth['uid'],
                            :token    => omniauth['credentials']['token'], 
                            :secret   => omniauth['credentials']['secret'])
    else
      authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
      self.email = omniauth.recursive_find_by_key("email")
    end
      self.email      = omniauth.recursive_find_by_key("email")
      self.last_name  = omniauth.recursive_find_by_key("last_name")
      self.first_name = omniauth.recursive_find_by_key("first_name")
      self.gender     = omniauth.recursive_find_by_key("gender")
  end
  
  def resource_type
    self.class.name.underscore.to_sym
  end
  
  

  
end
