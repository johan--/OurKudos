class KudoCategory < ActiveRecord::Base
  has_many :kudos
  validates :name,             :presence => true
  validates :kudo_category_id, :presence => true

  default_scope order("name ASC")

  class << self

    def seed!
      %w(Congratulations Athletic Academic Uniform
         Memorial Samaritan Thank You Career Honor
        Business Product Food).each do |name|
        create(:name => name)
      end
    end

    def collection_for_kudo_form
      KudoCategory.all.map{|category| [category.name, category.id]  }
    end



    end

end
