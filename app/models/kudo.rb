class Kudo < ActiveRecord::Base
  belongs_to :author,   :class_name => "User"
  belongs_to :kudoable, :polymorphic => true

  has_many  :kudo_copies
  has_many :recipients, :through => :kudo_copies

  has_one :kudo, :as => :kudoable

  attr_accessor  :to
  attr_accessible :subject, :body, :to

  before_create :set_kudoable, :prepare_copies

  validates :body, :presence => true

  def set_kudoable
    self.kudoable = self
  end

  def prepare_copies
    return if to.blank?
    return send_email_kudo if to =~ RegularExpressions.email

    recipients = []
    to.split(",").each do |id|
      recipient  = Identity.find(id.to_i).user rescue nil
       if recipient && !recipients.include?(recipient)
         recipients << recipient
         kudo_copies.build(:recipient_id => recipient.id, :folder_id => recipient.inbox.id)
       end
    end
    kudo_copies
  end

  def send_email_kudo

  end

end