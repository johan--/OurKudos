class FacebookFriend < ActiveRecord::Base
  belongs_to :user
  has_many :facebook_kudos, :foreign_key => "facebook_id"


  class << self

    def fetch_for user
      Delayed::Job.enqueue FacebookFriendsFetchJob.new user
    end

  end
end
