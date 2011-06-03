class FacebookFriend < ActiveRecord::Base
  belongs_to :user


  class << self

    def fetch_for user
      Delayed::Job.enqueue FacebookFriendsFetchJob.new user
    end
  end
end
