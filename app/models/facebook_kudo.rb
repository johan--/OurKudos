class FacebookKudo < ActiveRecord::Base
  has_one :kudo, :class_name => "KudoCopy", :as => :kudoable, :dependent => :destroy

  after_save :post_me!, :unless => :posted?

  def post_me!
     case kudo.share_scope
       when nil,'friends', 'recipient'
        self.response = kudo.author.post_facebook_kudo kudo
     end
    self.posted   = true
    save :validate => false
  end
  handle_asynchronously :post_me!

end