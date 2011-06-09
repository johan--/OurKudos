class TwitterKudo < ActiveRecord::Base
  has_one :kudo, :class_name => "KudoCopy", :as => :kudoable, :dependent => :destroy
  after_save :post_twitter, :if => :new_record?

  def post_twitter
    Delayed::Job.enqueue TwitterKudoPostJob.new self
  end

end