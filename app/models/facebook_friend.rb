class FacebookFriend < ActiveRecord::Base
  belongs_to :user
  has_many :facebook_kudos, :foreign_key => "facebook_id"

  scope :friends_by_name_for_user, ->(keyword, user) { where(:user_id => user.id).
                                                       where("lower(first_name) LIKE lower(?) OR lower(last_name) \
                                                              LIKE lower(?)",
                                                              "#{keyword}%", "#{keyword}%") }

  class << self

    def fetch_for user
      Delayed::Job.enqueue FacebookFriendsFetchJob.new user
    end

  end
end
