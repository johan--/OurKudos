class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :token_authenticatable, :confirmable, :lockable, :timeoutable, 
         :omniauthable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name,
                  :streetadress, :city, :state_or_province, :postal_code, :phone_number, :mobile_number
                  
  
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

  def self.new_with_session params, session
    super.tap do |user|
      if data = session[:omniauth]
        user.authentications.build(:provider => data['provider'], :uid => data['uid'])
      end
    end
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
  end
  
  def password_required?
    (authentications.empty? || !password.blank?) && super  
  end
  
  

  
end
