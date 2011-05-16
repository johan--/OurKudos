class Authentication < ActiveRecord::Base
  
  validates :provider, :presence => true
  validates :uid,      :presence => true
  validates :token,    :presence => true

  scope :for, ->(user) { where(:user_id => user.id) }

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
