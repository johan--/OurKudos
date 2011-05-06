class Role < ActiveRecord::Base
  has_and_belongs_to_many :users

  class << self

    def dropdown_size
      return scoped.length-1 if scoped.length < 10
      return 10
    end

  end
end
