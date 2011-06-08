class Kudo < ActiveRecord::Base
  belongs_to :author,   :class_name => "User"

  has_many  :kudo_copies
  has_many  :recipients, :through => :kudo_copies

  attr_accessor  :to, :share_scope
  attr_accessible :subject, :body, :to, :facebook_sharing, :twitter_sharing

  before_create :prepare_copies
  after_create  :post_twitter,   :if => :twitter_sharing?
  after_create  :post_facebook,  :if => :facebook_sharing?

  validates :body,        :presence => true

  #validates_with RemoteKudoValidator

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
                        :folder_id    => recipient.inbox.id,
                        :share_scope  => share_scope
      Friendship.process_friendships_between author, recipient
      Friendship.process_friendships_between recipient, author
  end

  def send_email_kudo recipient
    kudo_copies.build :temporary_recipient  => recipient,
                      :share_scope  => share_scope,
                      :kudoable => EmailKudo.create(:email => recipient)
  end

  def send_twitter_kudo recipient
    kudo_copies.build :temporary_recipient => recipient,
                      :share_scope  => share_scope,
                      :kudoable => TwitterKudo.create(:twitter_handle => recipient)
  end

  def post_twitter
    author.post_twitter_kudo self
  end

  def post_facebook
    author.post_facebook_kudo self
  end

  class << self
=begin
    def post_facebook_in_background kudo
       Delayed::Job.enqueue FacebookKudoPostJob.new kudo
    end
=end



  end


end