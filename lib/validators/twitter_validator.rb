class TwitterValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    record.errors[attribute] << (options[:message] || I18n.t(:please_authorize_with_twitter_first)) unless record.user.has_twitter_handle?(value)
    record.errors[attribute] << (options[:message] || I18n.t(:twitter_identity_already_exists)) unless record.user.has_twitter_handle?(value).blank?
  end


end
