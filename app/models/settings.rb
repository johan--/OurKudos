class Settings < ActiveRecord::Base

  class << self
    def seed
      create [
        { :name => "disable-social-sharing", :value => false }
      ]
    end

    def [](name)
      self.find_by_name name.to_s.gsub("_", "-")
    end

  end

  def to_param
    self.name
  end

end
