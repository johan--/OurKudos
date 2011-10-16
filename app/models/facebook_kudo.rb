class FacebookKudo < ActiveRecord::Base
  has_one :kudo, :class_name => "KudoCopy", :as => :kudoable, :dependent => :destroy

  scope :date_range, ->(from,to){ where(:created_at  => from..to) }

  attr_accessible   :identifier, :post_type

  after_save :post_me!, :unless => :posted?

  
  def post_me!
     case self.post_type 
       when nil
         self.response = kudo.author.post_to_friends_wall self.identifier, kudo.kudo
       when 'wall'
         self.response = kudo.author.post_to_friends_wall self.identifier, kudo.kudo
       when 'feed'
         self.response = kudo.author.post_facebook_kudo kudo.kudo
     end
    send_system_email
    self.posted   = true
    save :validate => false
  end
  handle_asynchronously :post_me!

  def facebook_friend
    @facebook_friend ||= FacebookFriend.where(:facebook_id => self.identifier).first
  end

  def send_system_email
    authentication = Authentication.find_by_uid(identifier)
    return false if authentication.blank? || authentication.provider != 'facebook'
    member  = authentication.user 
    UserNotifier.delay.social_system_kudo kudo.kudo, member if member.present?
  end
end
