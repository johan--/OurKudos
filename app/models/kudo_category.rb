class KudoCategory < ActiveRecord::Base
  has_many :kudos
  validates :name, :presence => true

  class << self

    def seed!
      %w(Congratulations Athletic Academic Uniform
         Memorial Samaritan Thank You Career Honor
        Business Product Food).each do |name|
        create(:name => name)
      end
    end



    end

end
