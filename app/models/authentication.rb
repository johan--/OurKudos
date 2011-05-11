class Authentication < ActiveRecord::Base
  
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
