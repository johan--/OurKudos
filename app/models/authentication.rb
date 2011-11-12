class Authentication < ActiveRecord::Base
  
  validates :provider, :presence => true
  validates :uid,      :presence => true, :uniqueness => true
  validates :token,    :presence => true, :uniqueness => true
  before_save :downcase_nickname

  acts_as_mergeable

  def downcase_nickname
    self.nickname = self.nickname.downcase
  end

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
