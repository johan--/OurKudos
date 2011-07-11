class Gift < ActiveRecord::Base
#attr_accessor :image_file_name
  # ================
  # ==Associations==
  belongs_to :merchant
  has_and_belongs_to_many :gift_groups
  has_attached_file :image, :styles => {:thumb => "128x145>", :standard => "300x300>"}
  # ================

  # ================
  # == Delegators ==
  delegate :name, :to => :gift_group, :prefix => true
  delegate :name, :to => :merchant, :prefix => true
  # ================

  # ================
  # = Validations ==
  validates :name,    :presence => true
  validates :link,    :presence => true
  validates :price,   :numericality => {:greater_than => 0} 
  # ================

  # ================
  # == Callbacks ==
  before_validation :retrieve_from_commission_junction, :on => :create
  # ================

  def retrieve_from_commission_junction
    #needs reactoring
      if self.auto_retrievable?
        merchant_code = self.merchant.affiliate_code

        info = OurKudos::CommissionJunction.api_call(self.merchant.affiliate_code, self.affiliate_code)
        unless info == "bad uri"
          doc = Nokogiri::XML(info)
          
          self.name = doc.xpath('//name').first.text
          self.link = doc.xpath('//buy-url').first.text
          self.description = doc.xpath('//description').first.text
          self.price = doc.xpath('//price').first.text
            
        else
          return false
        end
      end
  end

  def update_commission_junction
    #needs refactoring
    info = OurKudos::CommissionJunction.api_call(self.merchant.affiliate_code, self.affiliate_code)
    unless info == "bad uri"
      doc = Nokogiri::XML(info)
      self.price = doc.xpath('//price').first.text
      self.link = doc.xpath('//buy-url').first.text
      if self.save
        true
      else
        false
      end
    else
      false
    end
  end
  



  def auto_retrievable?
    if !self.merchant_id.blank? && self.merchant.affiliate_program.name == "Commission Junction" && !self.affiliate_code.blank? 
      return true
    else
      return false
    end
  end
    
end
