class FacebookFriendsFetchJob < Struct.new(:user)
  def perform
    user.fetch_and_save_friends
  end
end