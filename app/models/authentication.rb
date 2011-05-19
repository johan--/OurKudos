class Authentication < ActiveRecord::Base
  
  validates :provider, :presence => true
  validates :uid,      :presence => true, :uniqueness => true
  validates :token,    :presence => true, :uniqueness => true

  acts_as_mergeable

  # =================
  # = class methods =
  # =================
    
    def self.options_for_provider
      [['Twitter', 'twitter'],
       ['Facebook', 'facebook'],
       ['OKFoodFight', 'okfoodfight'],
       ['OKFoody', 'okfoody']  
      ]
    end

    self.options_for_provider.map(&:last).each do |prov|
      define_method "#{prov}?" do
        self.provider == prov
      end
    end
  
end
