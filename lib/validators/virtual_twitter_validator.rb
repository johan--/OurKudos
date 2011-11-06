class VirtualTwitterValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    identity = Identity.find(value).identity
    record.errors[attribute] << (options[:message] || I18n.t(:please_authorize_with_twitter_before_adding)) unless record.merger.has_twitter_handle?(identity)    
  end


end

