class KudoCopyObserver < ActiveRecord::Observer

  def after_create record
    UserNotifier.kudo(record.kudoable).deliver! if record.kudoable.is_a?(EmailKudo)
    record.author.friendships.find_by_friend_id(record.recipient.id).update_friendship_statistics
  end

end
