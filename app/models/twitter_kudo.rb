class TwitterKudo < ActiveRecord::Base
  has_one :kudo, :class_name => "KudoCopy", :as => :kudoable, :dependent => :destroy

  after_save :post

  def post
    Delayed::Job.enqueue(TwitterKudoPostJob.new(self)) if posted.blank?
  end

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

end