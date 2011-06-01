class Kudo < ActiveRecord::Base
  belongs_to :author,   :class_name => "User"
  belongs_to :kudoable, :polymorphic => true

  has_many  :kudo_copies
  has_many :recipients, :through => :kudo_copies

  has_one :kudo, :as => :kudoable

  attr_accessor  :to
  attr_accessible :subject, :body, :to

  before_create :prepare_copies

  validates :body, :presence => true

  def recipients_list
    to.split(",").map{ |id| id.gsub("'",'') }
  end

  def prepare_copies
    return if to.blank?

    system_recipients = []

    recipients_list.each do |id|
      recipient  = Identity.find(id.to_i).user rescue nil

       if recipient && !system_recipients.include?(recipient)
         system_recipients << recipient
         send_system_kudo recipient
       elsif recipient.blank? && id =~ RegularExpressions.email
         send_email_kudo id
       elsif recipient.blank? && id =~ RegularExpressions.twitter
         send_twitter_kudo id
       end

    end
    kudo_copies
  end

  def send_system_kudo recipient
    self.kudoable = self
    kudo_copies.build :recipient_id => recipient.id, :folder_id => recipient.inbox.id
  end

  def send_email_kudo recipient
    self.kudoable = EmailKudo.create :email => recipient
    kudo_copies.build :temporary_recipient  => recipient
  end

  def send_twitter_kudo recipient
    self.kudoable = TwitterKudo.create :twitter_handle => recipient
    kudo_copies.build :temporary_recipient => recipient
  end

end