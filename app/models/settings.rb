class Settings < ActiveRecord::Base

  class << self
    def seed!
      create [
        { :name => "social-sharing-enabled", :value => "yes" },
        { :name => "sign-up-disabled", :value => "no" },
        { :name => "test-environment-special-message", :value => "Special message goes here"}
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
