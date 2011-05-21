class Permission < ActiveRecord::Base

  belongs_to :user
  belongs_to :site

  before_create :create_tokens

  def create_tokens
    self.code, self.access_token, self.refresh_token = SecureRandom.hex(16), SecureRandom.hex(16), SecureRandom.hex(16)
  end

  def redirect_uri_for redirect_uri
    return redirect_uri + "&code=#{code}&response_type=code" if redirect_uri =~ /\?/
    redirect_uri + "?code=#{code}&response_type=code"
  end

  def start_expiry_period! n = 2
   self.update_attribute(:access_token_expires_at, n.days.from_now)
  end


  class << self

    def authenticate code, site_id
      where(:code => code, :site_id => site_id).first
    end

    def remove_old!
      delete_all(["created_at < ?", 3.days.ago])
    end


  end

end
