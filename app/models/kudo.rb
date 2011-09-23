class Kudo < ActiveRecord::Base
  belongs_to :author,   :class_name => "User"
  belongs_to :kudo_category

  has_many  :kudo_copies, :dependent => :destroy
  has_many  :recipients, :through => :kudo_copies

  has_many :kudo_flags, :dependent => :destroy

  attr_accessor    :js_validation_only, :archived_kudo, :facebook_shared, :twitter_shared
  attr_accessible  :subject, :body, :to, :share_scope,  :author_id,
                   :facebook_sharing, :twitter_sharing, :kudo_category_id

  before_create :fix_share_scope, :prepare_copies, :fix_links,  :if => :new_record?


  validates_with KudoValidator
  validates :body,        :presence => true, :unless => :js_validation_only # when this is set to true we are not running prepare copies, only recipient validation is run

  scope :public_kudos,            where(:share_scope => nil).where(:removed => false)
  scope :date_range, ->(from,to){ where(:created_at  => from..to) }
  scope :not_removed,             where(:removed => false)
  scope :public_or_friends_kudos, where("kudos.share_scope IS NULL OR kudos.share_scope = ?", 'friends')
  scope :author_or_recipient, ->(user) { not_removed.
                                         joins(:kudo_copies).
                                         select("DISTINCT kudos.*").
                                         where("kudos.created_at >= ?", user.created_at.to_s(:db)).
                                         where("kudos.author_id IN (#{user.friends_ids_list}) OR kudo_copies.recipient_id IN (#{user.friends_ids_list})")}
  scope :local_kudos, ->(user) { joins(:kudo_copies).
                                  where("kudo_copies.recipient_id IN (#{local_authors(user)})") }

  scope :for_dashboard, -> { joins(left_joins_categories).joins(left_joins_comments).joins(:author).joins(:recipients) }

  scope :shared_with_friends, lambda { |user|
      kudos  = Kudo.arel_table
      copies = KudoCopy.arel_table

      joins(:kudo_copies).where(kudos[:share_scope].eq('friends').
                                      and(copies[:recipient_id].in(user.friends_ids_list)).
                                      and(kudos[:created_at].gteq(user.created_at.to_s(:db)))
                                )
  }

  serialize :flaggers
  serialize :hidden_for
  serialize :blocked_commentators
  serialize :system_kudos_recipients_cache
                                        :kudo_category
  acts_as_commentable
  include OurKudos::Helpers::Sanitization

  include PgSearch

  pg_search_scope :serchterms_kudos,
                  :against => :body,
                  :associated_against => {
    :author        => [:first_name, :last_name, :postal_code, :city],
    :recipients    => [:first_name, :last_name, :postal_code, :city],
    :kudo_category => [:name],

  }



  def recipients_list
    to.split(",").map{ |id| id.gsub("'",'').gsub(" ",'') }
  end

  #TODO FIX THIS: THIS CODE LAUNCHES ABOUT 3 additional queries for each shown kudo (that gives us about 30 per page)
  def recipients_readable_list
    if to.present? && kudo_copies.size == 0
      to.gsub("'","")
    else
      #kudo_copies.map(&:copy_recipient).uniq.map {|r| r unless r.blank? }.compact.sort.join(",")
      #needs refactoring
      kudo_copies.map do |i|
        if !i.recipient.blank?
          i.recipient.secured_name
        else !i.temporary_recipient
          if i.kudoable_type == "TwitterKudo"
            "@#{i.temporary_recipient}"
          elsif i.kudoable_type == "FacebookKudo"
            friend = FacebookFriend.find_by_facebook_id(i.temporary_recipient)
            return "unknown recipient" if friend.nil?
            "#{friend.first_name} #{friend.last_name[0]}."
          else
            i.temporary_recipient
          end
        end
      end.uniq.compact.sort.join(",")
    end
  end

  def recipients_names_ids
    kudo_copies.map do |kc|
      if kc.recipient_id
        [kc.copy_recipient, kc.recipient_id]
      elsif kc.kudoable_type == "FacebookKudo"
        friend = FacebookFriend.find_by_facebook_id(kc.temporary_recipient)
        friend.blank? ? ["unknown recipient", nil] : ["#{friend.first_name} #{friend.last_name[0]}.", nil]
      else kc.temporary_recipient
        ["#{kc.temporary_recipient}", nil]
      end
    end.compact
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

  def recipients_ids
    @recipients_ids ||= kudo_copies.map(&:recipient_id).compact.flatten.uniq
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

  def recipients_emails
    kudo_copies.map do |copy|
      copy.temporary_recipient.blank? ?
          copy.recipient.email : copy.temporary_recipient
    end.compact.flatten.uniq
  end

  def author_as_recipient?
    !author_as_recipient.blank?
  end

  def prepare_copies
    return if to.blank? || js_validation_only # stop processing if validation with javascript

    system_recipients = []
    set_as_private if all_recipients_are_emails?

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
         send_facebook_kudo(id.gsub("fb_",'')) if Kudo.social_sharing_enabled?
       elsif recipient.blank? && id =~ RegularExpressions.merchant
         send_merchant_kudo(id.gsub(RegularExpressions.merchant,''))
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

      self.system_kudos_recipients_cache << recipient.id

      Friendship.process_friendships_between author, recipient
      Friendship.process_friendships_between recipient, author
  end

  def send_email_kudo recipient
      id = Identity.find_by_identity_and_identity_type(recipient, "email").user rescue nil

      return send_system_kudo(id) unless id.blank?
      kudo_copies.build :temporary_recipient  => recipient,
                        :author_id    => author.id,
                        :share_scope  => share_scope,
                        :kudoable => EmailKudo.create(:email => recipient)
      author.increase_invitations :sent
  end

  def send_twitter_kudo recipient
    kudo_copies.build :temporary_recipient => recipient,
                      :share_scope  => share_scope,
                      :author_id    => author.id,
                      :kudoable => TwitterKudo.create(:twitter_handle => recipient)
  end

  def send_facebook_kudo recipient
    unless facebook_shared #prevents to send multiple copies
      kudo_copies.build :temporary_recipient => recipient,
                        :share_scope  => share_scope,
                        :author_id    => author.id,
                        :kudoable => FacebookKudo.create(:identifier => recipient)
      self.facebook_shared = true
    end
  end

  def send_social_kudo recipient = nil
      send_twitter_kudo(author.twitter_auth.nickname)  if twitter_sharing?  && share_scope.blank? && !author.twitter_auth.blank?
      send_facebook_kudo(author.facebook_auth.uid)     if facebook_sharing? && share_scope.blank? && !author.facebook_auth.blank?
      send_facebook_kudo(recipient)                    if !recipient.blank? && share_scope == 'friends'
  end

  def all_recipients_are_emails?
    !recipients_list.map {|recipient| recipient.match(RegularExpressions.email) }.include?(nil)
  end

  def set_as_private
    self.share_scope = 'recipient'
  end

  def fix_share_scope
    self.share_scope = nil if self.share_scope == 'on'       # we can't pass nil in form builder radio
  end

  def social_sharing?
    facebook_sharing? || twitter_sharing?
  end

  def category
    return '' if kudo_category_id.blank?

    kudo_category.name.to_s
  end

  def soft_destroy
    update_attribute :removed, true
  end

  def can_be_deleted_by? user
    author == user || user_is_only_recipient?(user) == true || is_last_to_delete?(user) == true
  end

  def recipients_who_have_not_deleted
    system_kudos_recipients_cache - hidden_for  
  end

  def is_last_to_delete? user
    recipients_who_have_not_deleted.length == 1 && recipients_who_have_not_deleted.first == user.id
  end

  def user_is_only_recipient? user
    recipients.size == 1 && recipients.include?(user) 
  end

  def people_received_ids
    kudo_copies.map(&:recipient_id).compact.flatten.uniq.sort
  end

  def set_me_and_my_copies_scope_to scope, flagger
    Kudo.transaction do
      self.share_scope = scope
      add_to_my_flaggers flagger
      self.save :validate => false
      kudo_copies.each do |copy|
        copy.update_attribute :share_scope, scope if copy.share_scope != 'recipient'
      end
    end
  end

  def add_to_my_flaggers flagger, save = false
    flaggers << flagger.id
    self.flaggers = self.flaggers.uniq
    save(:validate => false) if save
  end

  def all_recipients_are_flaggers?
    flagged_recipients = flaggers.select {|flagger|
                            people_received_ids.include? flagger}

    flagged_recipients.sort == people_received_ids.sort
  end

  def visible_for? user = nil
    return false if user && is_flagged_by?(user) || is_hidden_for?(user)
    true
  end

  #sent kudos can be deleted only by author, others can just hide it in newsfeed.
  #If this array includes user id, it won't show up
  def is_hidden_for? user
     hidden_for.include?(user.id)
  end

  def hide_for! user
    return true if is_hidden_for?(user)

    hidden_for << user.id
    update_attribute :hidden_for, hidden_for.uniq
  end

  def is_flagged_by? user
    flaggers.include?(user.id)
  end

  def flaggers_ids_names
    @flaggers_ids_names ||= flaggers.map do |user_id|
      user = User.find user_id
      [user.id, user.to_s]
    end
  end

  def archive_copy
    self.archived_kudo ||= ArchivedKudo.new

    self.archived_kudo.attributes = attributes.delete_if {
        |attr| attr ==  "has_been_improperly_flagged"
    }
    self.archived_kudo
  end

  def archivize
    archive_copy
    archive_copy.flaggers = flaggers_from_kudo_flags
    self.archived_kudo.save :validate => false
    archived_kudo
  end

  def improperly_flagged!
    update_attribute :has_been_improperly_flagged, true
  end

  def flaggers_from_kudo_flags
    kudo_flags.map(&:flagger).map(&:id).sort
  end

  def disable_moderation!
    update_attribute :comments_moderation_enabled, false
  end

  def disable_commenting!
    update_attribute :comments_disabled, true
  end

  def block_commentator! user, savedb = true
    self.comments.for_user(user).destroy_all

    blocked_commentators << user.id
    save(:validate => false) if savedb
  end

  def remove_from_system_kudos_cache user
    system_kudos_recipients_cache.delete(user.id)
    save :validate => false
  end

  def fix_links
    clean_up_links! if author.credibility == 0
  end



  class << self

    def local_authors user
      User.local_users user
    end

    def social_sharing_enabled?
      @social_sharing_enabled ||= Settings[:social_sharing_enabled].value == 'yes'
    end

    def newsfeed_for user
      joins(:author).joins(:kudo_copies).
          joins(left_joins_categories).
          joins(left_joins_comments).
          select("DISTINCT kudos.*").
          where(:removed => false).
          where("kudos.created_at > ?", user.created_at.to_s(:db)).
          where("#{shared_sql(user)} OR #{nearby_kudos_sql(user)}")
    end

    def for_identity author, identity, message
      kudo = Kudo.new :to        => identity.to_s,
                      :body      => message,
                      :author_id => author

      kudo.save :validate => false
    end

    def allowed_tabs
      %w{received sent newsfeed searchterms}
    end

    #this shouldn't be run at all on large datasets
    def count_comments!
      all.each do |kudo|
        current_count = kudo.comments.size
        kudo.update_attribute(:comments_count, current_count) if kudo.comments_count != current_count
      end
    end

    def options_for_sort
      [['newest kudos first', 'date_desc'],
       ['oldest kudos first', 'date_asc'],
       ['most commented first', 'comments_desc']
        ]
    end

    def allowed_sorting
      %w{comments_asc comments_desc date_asc date_dsc}
    end


  end


end
