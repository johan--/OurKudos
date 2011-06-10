class FacebookKudo < ActiveRecord::Base
  has_one :kudo, :class_name => "KudoCopy", :as => :kudoable, :dependent => :destroy
  belongs_to :facebook_friend, :foreign_key => "identifier"

  after_save :post_me!, :unless => :posted?

  def post_me!
     case kudo.share_scope
       when nil
        self.response = kudo.author.post_facebook_kudo kudo
       when 'friends', 'recipient'
        self.response = kudo.author.post_to_friends_wall temporary_recipient, kudo
     end
    self.posted   = true
    save :validate => false
  end
  handle_asynchronously :post_me!

end