class VirtualMerge < ActiveRecord::Base
  belongs_to :merger, :foreign_key => :merged_by, :class_name => "User"
  belongs_to :merged, :foreign_key => :merged_id, :class_name => "VirtualUser"
  belongs_to :identity
  has_one :confirmation, :as => :confirmable, :dependent => :destroy

  validates :merged_by, :presence => true
  validates :identity_id, :virtual_twitter => true, :unless => :not_twitter?
  # ================
  # == extensions ==
  # ================

  #before_save :check_twitter_auth, :unless => :not_twitter?
  after_save :save_confirmation, :if => :not_twitter?
  after_save :save_twitter_confirmation!, :unless => :not_twitter?
  include OurKudos::Confirmable
  # ======================
  # == instance methods ==
  # ======================

   def run!
     #verbose to hack around frozen hash error
     VirtualMerge.transaction do
      identity_to_update = self.identity
      identity_to_update.identifiable_id = self.merged_by
      identity_to_update.identifiable_type = 'User'
      identity_to_update.save(:validate => false)
      identity_to_update.confirmation.confirm!

      update_copies
      
      self.merged.destroy 
     end
   end

   def not_twitter?
     return true if self.identity.blank?
     self.identity.identity_type != 'twitter'
   end

    def update_copies
      kudo_copies = KudoCopy.where(:recipient_id => self.merged.id,
                                   :recipient_type => self.merged.class.to_s)
      kudo_copies.each do |copy|
        copy.update_attributes(:recipient_id => self.merger.id,
                               :recipient_type => self.merger.class.to_s)
      end
    end

    def save_twitter_confirmation!
      update_identity = self.run!
      return false if update_identity == false
      create_confirmation( :confirmable_type  => self.identity.class.name,
                            :confirmable_id   => self.identity.id,
                            :confirmed        => true) if needs_confirmation?
    end

  #
  # =================
  # = class methods =
  # =================
  class << self

    def accounts new_user, identity
      return VirtualMerge.new if identity.blank?
        new_user.virtual_merges.build  :merged_by         => new_user.id,
                                       :merged_id         => identity.identifiable_id,
                                       :identity_id       => identity.id        

    end

 end
end
