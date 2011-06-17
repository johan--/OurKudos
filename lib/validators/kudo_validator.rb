class KudoValidator < ActiveModel::Validator

  def validate record
    record.errors[:base] << I18n.t(:cannot_send_kudos_to_yourself_sorry, :own_identity => record.author_as_recipient_readable_list) if record.author_as_recipient?
    record.errors[:base] << I18n.t(:you_cannot_send_an_empty_kudo)  if record.to.blank?
    record.errors[:base] << I18n.t(:invalid_recipients, :recipients => record.invalid_recipients.join(",")) if record.has_invalid_recipients?
  end

end