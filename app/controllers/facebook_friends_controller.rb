class FacebookFriendsController < ApplicationController
  before_filter :authenticate_user!
  layout "registered"

  def index
    @facebook_friends = current_user.facebook_friends.sort! { |a,b| a.last_name.downcase <=> b.last_name.downcase }
  end

  def create
    FacebookFriend.fetch_for current_user
    redirect_to user_path(current_user), :notice => I18n.t(:we_started_fetching_your_friends_list_from_facebook)
  end

end
