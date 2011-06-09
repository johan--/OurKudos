class TwitterKudo < ActiveRecord::Base
  has_one :kudo, :class_name => "KudoCopy", :as => :kudoable, :dependent => :destroy

  after_save :post_it

  def post_it
    Delayed::Job.enqueue(TwitterKudoPostJob.new(self)) if posted.blank?
  end

end