class FacebookFriendsController < ApplicationController
  layout "registered"

  def index
    @facebook_friends = current_user.facebook_friends
  end

  def create
    FacebookFriend.fetch_for current_user
    ActiveRecord::Base.logger.info "Time is now:#{Time.now}"
    redirect_to user_facebook_friends_path(current_user), :notice => I18n.t(:we_started_fetching_your_friends_list_from_facebook)
  end

end
