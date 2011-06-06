class RemoteKudoValidator < ActiveModel::Validator

  def validate record
    record.errors[:base] << I18n.t(:unable_to_post_this_kudo_on_twitter)  if record.twitter_sharing?  && !record.author.post_twitter_kudo(record)
    record.errors[:base] << I18n.t(:unable_to_post_this_kudo_on_facebook) if record.facebook_sharing? && !record.author.post_facebook_kudo(record)
  end


end