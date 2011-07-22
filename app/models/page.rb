class Page < ActiveRecord::Base
  validates :title,  :presence => true
  validates :slug,   :presence => true
  validates :locale, :presence => true
  validates :body,   :presence => true

  validates :slug, :uniqueness => true, :scope => :locale

  SLUGS = {
    "faq" => "FAQ",
    "terms-of-service" => "Terms of service",
    "about-us" => "About us",
    "contact-us" => "Contact Us",
    "privacy-policy" => "Privacy Policy"
  }


  class << self
    def find_with_locale slug, locale
      self.where(:slug => slug, :locale => locale).first
    end

    def seed!
      SLUGS.each{|slug| Page.create(:slug=> slug[0], :title => slug[1], :locale => "en", :body => "placeholder")}
    end
  end

end