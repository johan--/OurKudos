require 'key_generator'
class Merge < ActiveRecord::Base

  belongs_to :merger, :foreign_key => :merged_by, :class_name => "User"
  belongs_to :merged, :foreign_key => :merged_id, :class_name => "User"
  belongs_to :identity

  validates :identity_id, :presence => true
  validates :identity_id, :identity_primary => true

  before_save :generate

  include OurKudos::KeyGenerator

  def set_as_confirmed!
    update_attribute :email_confirmed, true
  end

  class << self

    def accounts new_user, identity
      return Merge.new if identity.blank?

        new_user.merges.build  :merged_by         => new_user.id,
                               :merged_id         => identity.user_id,
                               :merged_with_email => identity.user.email,
                               :identity_id       => identity.id        

    end

  end

end