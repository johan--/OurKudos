class CommentValidator < ActiveModel::Validator

  def validate record
      record.errors[:base] << I18n.t(:you_cannot_longer_post_messages_for_this_kudo)  if record.is_blocked_sender?

  end

end