class Kudo < ActiveRecord::Base
  belongs_to :author,   :class_name => "User"

  has_many  :kudo_copies
  has_many  :recipients, :through => :kudo_copies

  attr_accessor  :to
  attr_accessible :subject, :body, :to, :share_scope,
                  :facebook_sharing, :twitter_sharing

  before_create :fix_share_scope, :prepare_copies

  validates :body,        :presence => true

  scope :public_kudos, where(:share_scope => nil)
  #validates_with RemoteKudoValidator

  def recipients_list
    to.split(",").map{ |id| id.gsub("'",'') }
  end

  def recipients_readable_list
    kudo_copies.map(&:copy_recipient).uniq.join(", ")
  end

  def prepare_copies
    return if to.blank?

    system_recipients = []

    recipients_list.each do |id|
      identity   = Identity.find(id.to_i) rescue nil
      recipient  = identity.user rescue nil

       if !recipient.blank? && !system_recipients.include?(recipient)
         system_recipients << recipient
         send_system_kudo(recipient)
         send_social_kudo if Settings[:social_sharing_enabled].value == 'yes' && social_sharing?

       elsif recipient.blank? && id =~ RegularExpressions.email
         send_email_kudo id
       elsif recipient.blank? && id =~ RegularExpressions.twitter
         send_twitter_kudo id.gsub("@",'')
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

  def send_facebook_kudo recipient
    kudo_copies.build :temporary_recipient => recipient,
                      :share_scope  => share_scope,
                      :kudoable => FacebookKudo.create(:identifier => recipient)
  end

  def send_social_kudo
      send_twitter_kudo(author.twitter_auth.nickname)  if share_scope.blank? && !author.twitter_auth.blank?
      send_facebook_kudo(author.facebook_auth.uid)     if share_scope.blank? && !author.facebook_auth.blank?
  end

  def fix_share_scope
    self.share_scope = nil if self.share_scope == 'on'       # we can't pass nil in form builder radio
  end

  def social_sharing?
    facebook_sharing? || twitter_sharing?
  end



end