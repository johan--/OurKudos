class FacebookFriendsFetchJob < Struct.new(:user, :kudo)
  def perform
    user.post_facebook_kudo kudo
  end
end