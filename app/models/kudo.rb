class Kudo < ActiveRecord::Base
  belongs_to :author,   :class_name => "User"

  has_many  :kudo_copies
  has_many  :recipients, :through => :kudo_copies

  attr_accessor  :to, :js_validation_only
  attr_accessible :subject, :body, :to, :share_scope,
                  :facebook_sharing, :twitter_sharing

  before_create :fix_share_scope, :prepare_copies

  validates :body,        :presence => true, :unless => :js_validation_only

  scope :public_kudos,            where(:share_scope => nil)
  scope :public_or_friends_kudos, where("kudos.share_scope IS NULL OR kudos.share_scope = ?", 'friends')
  scope :author_or_recipient, ->(user) { joins(:kudo_copies).
                                         select("DISTINCT kudos.*").
                                         where("kudos.created_at >= ?", user.created_at).
                                         where("kudos.author_id IN (?) OR kudo_copies.recipient_id IN (?)",
                                                user.friends_ids_list, user.friends_ids_list) }

  validates_with KudoValidator

  def recipients_list
    to.split(",").map{ |id| id.gsub("'",'').gsub(" ",'') }
  end

  def recipients_readable_list
    kudo_copies.map(&:copy_recipient).uniq.join(", ")
  end

  def author_as_recipient
    @author_as_recipient ||= recipients_list.select do |recipient|
     author.identities_ids.include?(recipient.to_i) ||
          author.identities.map(&:identity).include?(recipient)
    end
  end

  def invalid_recipients
    recipients_list.select do |recipient|
      recipient if recipient.to_i == 0 &&
          !allowed_recipient?(recipient)
      end
  end

  def allowed_recipient? recipient
    recipient.match(RegularExpressions.twitter) ||
      recipient.match(RegularExpressions.email) ||
        recipient.match(RegularExpressions.facebook_friend)
  end

  def has_invalid_recipients?
    !invalid_recipients.blank?
  end

  def author_as_recipient_readable_list
    author_as_recipient.map do |rec|
      if rec.to_i != 0 #ids
        author.identities.find(rec.to_i).identity
      else
        rec if rec.to_i == 0 #strings
      end
    end.join(", ")
  end

  def author_as_recipient?
    !author_as_recipient.blank?
  end

  def prepare_copies
    return if to.blank? || js_validation_only # stop processing if validation with javascript

    system_recipients = []

    recipients_list.each do |id|

      identity   = Identity.find(id.to_i) rescue nil
      recipient  = identity.user rescue nil

       if !recipient.blank? && !system_recipients.include?(recipient)
         system_recipients << recipient
         send_system_kudo(recipient)
         send_social_kudo if Kudo.social_sharing_enabled? && social_sharing?

       elsif recipient.blank? && id =~ RegularExpressions.email
         send_email_kudo id
       elsif recipient.blank? && id =~ RegularExpressions.twitter
         send_twitter_kudo id.gsub("@",'')   if Kudo.social_sharing_enabled?
       elsif recipient.blank? && id =~ RegularExpressions.facebook_friend
         send_social_kudo(id.gsub("fb_",'')) if Kudo.social_sharing_enabled?
       end


    end
    kudo_copies
  end

  def send_system_kudo recipient
      kudo_copies.build :recipient_id => recipient.id,
                        :author_id    => author.id,
                        :kudoable     => self,
                        :folder_id    => recipient.inbox.id,
                        :share_scope  => share_scope

      Friendship.process_friendships_between author, recipient
      Friendship.process_friendships_between recipient, author


  end

  def send_email_kudo recipient
      kudo_copies.build :temporary_recipient  => recipient,
                        :author_id    => author.id,
                      :share_scope  => share_scope,
                      :kudoable => EmailKudo.create(:email => recipient)
  end

  def send_twitter_kudo recipient
    kudo_copies.build :temporary_recipient => recipient,
                      :share_scope  => share_scope,
                      :author_id    => author.id,
                      :kudoable => TwitterKudo.create(:twitter_handle => recipient)
  end

  def send_facebook_kudo recipient
    kudo_copies.build :temporary_recipient => recipient,
                      :share_scope  => share_scope,
                      :author_id    => author.id,
                      :kudoable => FacebookKudo.create(:identifier => recipient)
  end

  def send_social_kudo(recipient = nil)
      send_twitter_kudo(author.twitter_auth.nickname)  if share_scope.blank? && !author.twitter_auth.blank?
      send_facebook_kudo(author.facebook_auth.uid)     if share_scope.blank? && !author.facebook_auth.blank?
      send_facebook_kudo(recipient)                    if !recipient.blank? && share_scope == 'friends'
  end

  def fix_share_scope
    self.share_scope = nil if self.share_scope == 'on'       # we can't pass nil in form builder radio
  end

  def social_sharing?
    facebook_sharing? || twitter_sharing?
  end


  class << self

    def social_sharing_enabled?
      @social_sharing_enabled ||= Settings[:social_sharing_enabled].value == 'yes'
    end

  end


end