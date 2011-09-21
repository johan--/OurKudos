class FacebookKudo < ActiveRecord::Base
  has_one :kudo, :class_name => "KudoCopy", :as => :kudoable, :dependent => :destroy

  scope :date_range, ->(from,to){ where(:created_at  => from..to) }

  after_save :post_me!, :unless => :posted?

  def post_me!
     case self.kudo.share_scope
       when nil
        self.response = kudo.author.post_facebook_kudo kudo.kudo
       when 'friends'
         self.response = kudo.author.post_to_friends_wall identifier, kudo.kudo
       when 'recipient'
         self.response = kudo.author.post_to_friends_wall identifier, kudo.kudo
     end

    self.posted   = true
    save :validate => false
  end
  handle_asynchronously :post_me!

  def facebook_friend
    @facebook_friend ||= FacebookFriend.where(:facebook_id => self.identifier).first
  end

end