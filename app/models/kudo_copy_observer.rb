class KudoCopyObserver < ActiveRecord::Observer

  def after_create record
    if record.kudoable.is_a?(EmailKudo)
      UserNotifier.delay.kudo(record.kudoable)
    elsif record.kudoable.is_a?(Kudo)
      UserNotifier.delay.system_kudo record
      user = record.author
      if record.recipient.is_a?(User)
        friendships = user.friendships.find_by_friend_id(record.recipient.id)
        friendships.update_friendship_statistics unless user.friendships.blank?
      end
    end
  end

end
