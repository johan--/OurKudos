class Kudo < ActiveRecord::Base
  belongs_to :author,   :class_name => "User"
  belongs_to :kudoable, :polymorphic => true

  has_many  :kudo_copies
  has_many :recipients, :through => :kudo_copies

  has_one :kudo, :as => :kudoable

  attr_accessor  :to
  attr_accessible :subject, :body, :to

  before_create :build_inbox

   def inbox
     folders.find_by_name I18n.t(:inbox_name)
   end

   def build_inbox
     folders.build :name => I18n.t(:inbox_name)
   end


  def prepare_copies
    return if to.blank?

    to.each do |recipient|
      recipient = Identity.find_all_by_identity(identity).user
      kudo_copies.build(:recipient_id => recipient.id, :folder_id => recipient.inbox.id)
    end
  end
end