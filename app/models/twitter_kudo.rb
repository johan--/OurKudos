class TwitterKudo < ActiveRecord::Base
  has_one :kudo, :class_name => "KudoCopy", :as => :kudoable, :dependent => :destroy

  after_save :post_me!, :unless => :posted?

  scope :date_range, ->(from,to){ where(:created_at  => from..to) }

  def post_me!
     case kudo.share_scope
       when nil
        self.response = kudo.author.post_twitter_kudo kudo
       when 'friends', 'recipient'
        self.response = kudo.author.direct_message_to twitter_handle, kudo
     end
    self.posted   = true
    save :validate => false
  end
  handle_asynchronously :post_me!

end