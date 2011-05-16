class Merge < ActiveRecord::Base

  # ================
  # = associations =
  # ================
  belongs_to :merger, :foreign_key => :merged_by, :class_name => "User"
  belongs_to :merged, :foreign_key => :merged_id, :class_name => "User"
  belongs_to :identity
  has_one :confirmation, :as => :confirmable, :dependent => :destroy

  # ================
  # = validations  =
  # ================
  validates :identity_id, :presence => true
  validates :identity_id, :identity_primary => true

  # ================
  # == extensions ==
  # ================

  after_save :save_confirmation
  
  include OurKudos::Confirmable

  # ======================
  # == instance methods ==
  # ======================

   def merge_accounts
     Merge.transaction do
      self.merged.set_identities_as_destroyable

      Merge.mergeables.each do |model|
          objects = self.merged.send model.to_s.underscore.pluralize
          model.change_objects_owner_to objects, self.merger          
      end

      self.merged.destroy
     end
   end

  # =================
  # = class methods =
  # =================
  class << self

    def accounts new_user, identity
      return Merge.new if identity.blank?
        new_user.merges.build  :merged_by         => new_user.id,
                               :merged_id         => identity.user_id,
                               :merged_with_email => identity.user.email,
                               :identity_id       => identity.id        

    end

    def mergeables
     OurKudos::Acts::Mergeable.mergeables # (i.e [Identity, Authentication])
    end


 end

end
