class Authentication < ActiveRecord::Base
  
  validates :provider, :presence => true
  validates :uid,      :presence => true
  validates :token,    :presence => true

  acts_as_mergeable
  
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
