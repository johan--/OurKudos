class TwitterValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    record.errors[attribute] << (options[:message] || I18n.t(:please_authorize_with_twitter_first)) unless record.user.has_twitter_handle?(value)
  end


end
