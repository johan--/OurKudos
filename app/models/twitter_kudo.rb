class TwitterKudo < ActiveRecord::Base
  has_one :kudo, :class_name => "KudoCopy", :as => :kudoable, :dependent => :destroy

  after_save :post_me!, :unless => :posted?

  scope :date_range, ->(from,to){ where(:created_at  => from..to) }

  def post_me!
    case tweet_type
      when 'self'
        self.response = kudo.author.post_twitter_kudo kudo.body
      when 'mention'
        message = build_message kudo.kudo
        self.response = kudo.author.post_twitter_kudo message
    end
    send_system_email
    self.posted   = true
    save :validate => false
  end
  handle_asynchronously :post_me!

  def send_system_email
    identity = Identity.where('identity = ? AND identity_type = ?', twitter_handle, 'twitter').first
    return false if identity.blank? 
    #return false if identity.identifiable == kudo.author
    return false if identity.identifiable.id == kudo.author_id
    member  = identity.identifiable
    UserNotifier.delay.social_system_kudo kudo.kudo, member if member.present? && member.is_a?(User)
  end

  def build_message kudo
    message = kudo.body
    recipient = kudo_twitter_recipients kudo.recipients_list
    #still need a method to ensure message is 140chars
    if recipient_is_in_kudo_body? recipient
      message
    else
      recipient + " " + message     
    end
  end

  def recipient_is_in_kudo_body?(recipient)
    return true if kudo.kudo.body.include?(recipient)
    false
  end

  def kudo_twitter_recipients recipients  
    twitter_recipients_string = []
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
    #twitter_recipients_string.join(", ")
    twitter_recipients_string.first
  end
end
