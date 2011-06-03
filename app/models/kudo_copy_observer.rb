class KudoCopyObserver < ActiveRecord::Observer

  def after_create record
    if record.kudoable.is_a?(EmailKudo)
      UserNotifier.delay.kudo(record.kudoable)
    else
      record.author.friendships.find_by_friend_id(record.recipient.id).update_friendship_statistics
    end
  end

end
