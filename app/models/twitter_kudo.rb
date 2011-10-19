class TwitterKudo < ActiveRecord::Base
  has_one :kudo, :class_name => "KudoCopy", :as => :kudoable, :dependent => :destroy

  after_save :post_me!, :unless => :posted?

  scope :date_range, ->(from,to){ where(:created_at  => from..to) }

  #def post_me!
  #   case kudo.share_scope
  #     when nil
  #      self.response = kudo.author.post_twitter_kudo kudo
  #     when 'friends', 'recipient'
  #      self.response = kudo.author.direct_message_to twitter_handle, kudo
  #   end
  #  send_system_email
  #  self.posted   = true
  #  save :validate => false
  #end
  #handle_asynchronously :post_me!
  
  def post_me!
    case tweet_type
      when 'self'
        self.response = kudo.author.post_twitter_kudo kudo.body
      when 'mention'
        message = build_message kudo.kudo
        self.response = kudo.author.post_twitter_kudo message
        #self.response = kudo.author.direct_message_to twitter_handle, kudo
    end
    send_system_email
    self.posted   = true
    save :validate => false
  end
  handle_asynchronously :post_me!

  def send_system_email
    identity = Identity.where('identity = ? AND identity_type = ?', twitter_handle, 'twitter').first
    return false if identity.blank? 
    member  = identity.user 
    UserNotifier.delay.social_system_kudo kudo.kudo, member if member.present?
  end

  def build_message kudo
    message = kudo.body
    recipients = kudo_twitter_recipients kudo.recipients_list
    #still need a method to ensure message is 140chars
    message + " " + recipients
  end

  def kudo_twitter_recipients recipients  
    twitter_recipients_string = []
    #twitter_recipients_string << temporary_recipient if temporary_recipient[0] == "@"
    recipients.each do |id|
      if id[0] == "@"
        twitter_recipients_string << id
        next
      end
      identity   = Identity.find(id.to_i) rescue nil
      if identity.present? && identity.identity_type == 'twitter' 
        twitter_recipients_string << "@#{identity.identity}"
      end
    end
    twitter_recipients_string.join(", ")
  end
end
