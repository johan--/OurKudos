class ForbiddenPassword < ActiveRecord::Base

  validates :password, :presence => true, :uniqueness => true

  def to_s
    password.downcase
  end

  class << self

    def exists? pass
      !find_by_password(pass).blank?
    end

  end

end
