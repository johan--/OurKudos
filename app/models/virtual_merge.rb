class VirtualMerge < ActiveRecord::Base
  belongs_to :merger, :foreign_key => :merged_by, :class_name => "User"
  belongs_to :merged, :foreign_key => :merged_id, :class_name => "VirtualUser"
  belongs_to :identity
  has_one :confirmation, :as => :confirmable, :dependent => :destroy
  # ================
  # == extensions ==
  # ================

  after_save :save_confirmation
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
      
      self.merged.destroy 
      
     end
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
