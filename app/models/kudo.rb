class Kudo < ActiveRecord::Base
  belongs_to :author,   :class_name => "User"

  has_many  :kudo_copies
  has_many  :recipients, :through => :kudo_copies

  attr_accessor  :to
  attr_accessible :subject, :body, :to, :facebook_sharing, :twitter_sharing

  before_create :prepare_copies
  #after_create  :post_self_in_background, :if => :has_remote_resource?

  validates :body, :presence => true

  validates_with RemoteKudoValidator

  def recipients_list
    to.split(",").map{ |id| id.gsub("'",'') }
  end

  def recipients_readable_list
    kudo_copies.map(&:copy_recipient).join(", ")
  end

  def prepare_copies
    return if to.blank?

    system_recipients = []

    recipients_list.each do |id|
      recipient  = Identity.find(id.to_i).user rescue nil

       if !recipient.blank? && !system_recipients.include?(recipient)
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
      kudo_copies.build :recipient_id => recipient.id,
                        :kudoable     => self,
                        :folder_id    => recipient.inbox.id
      Friendship.process_friendships_between author, recipient
      Friendship.process_friendships_between recipient, author
  end

  def send_email_kudo recipient
    kudo_copies.build :temporary_recipient  => recipient,
                      :kudoable => EmailKudo.create(:email => recipient)
  end

  def send_twitter_kudo recipient
    kudo_copies.build :temporary_recipient => recipient,
                      :kudoable => TwitterKudo.create(:twitter_handle => recipient)
  end

  def has_remote_resource?
    !facebook_sharing.blank? || !twitter_sharing.blank?
  end

  def post_self_in_background provider = :facebook
    Kudo.send "post_#{provider}_in_background", self
  end

  class << self

    def post_facebook_in_background kudo
       Delayed::Job.enqueue FacebookKudoPostJob.new kudo
    end

  end


end