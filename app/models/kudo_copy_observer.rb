class KudoCopyObserver < ActiveRecord::Observer

  def after_create record
    if record.kudoable.is_a?(EmailKudo)
      UserNotifier.delay.kudo(record.kudoable)
    elsif record.kudoable.is_a?(Kudo)
      user = record.author
      user.friendships.find_by_friend_id(record.recipient.id).update_friendship_statistics
    end
  end

end