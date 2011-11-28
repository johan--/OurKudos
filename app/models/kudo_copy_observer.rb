class KudoCopyObserver < ActiveRecord::Observer

  def after_create record
    if record.kudoable.is_a?(EmailKudo)
      UserNotifier.delay.kudo(record.kudoable)
    elsif record.kudoable.is_a?(Kudo) && record.author_id != record.recipient_id
      UserNotifier.delay.system_kudo record
      user = record.author
      if record.recipient.is_a?(User)
        friendships = Friendship.where(:user_id => user.id,
                                       :friendable_id => record.recipient.id,
                                       :friendable_type => record.recipient.class.to_s).first
        #this is duplicating logic in the send_system_kudo method
        #friendships = user.friendships.find_by_friend_id(record.recipient.id)
        #friendships.update_friendship_statistics unless user.friendships.blank?
      unless user.friendships.blank?
        user.friendships.find_by_friend_id(record.recipient.id).update_friendship_statistics
      end
    end
  end

end
