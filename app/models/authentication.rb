class Authentication < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  
  belongs_to :user
  
  validates :provider, :presence => true
  validates :uid,      :presence => true
  validates :token,    :presence => true
  
  class << self 
    
    def options_for_provider
      [['Twitter', 'twitter'],
       ['Facebook', 'facebook'],
       ['OKFoodFight', 'okfoodfight'],
       ['OKFoody', 'okfoody']  
      ]
    end
    
    
    
  end  
end
