class KudoCopyObserver < ActiveRecord::Observer

  def after_create record
    if record.kudoable.is_a?(EmailKudo)
      UserNotifier.delay.kudo(record.kudoable)
    elsif record.kudoable.is_a?(Kudo) || record.author_id != record.recipient_id
      UserNotifier.delay.system_kudo record
      user = record.author
      unless user.friendships.blank?
        user.friendships.find_by_friend_id(record.recipient.id).update_friendship_statistics
      end
    end
  end

end
