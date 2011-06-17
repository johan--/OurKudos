class KudoValidator < ActiveModel::Validator

  def validate record
    record.errors[:base] << I18n.t(:cannot_send_kudos_to_yourself_sorry, :own_identity => record.author_as_recipient_readable_list) if record.author_as_recipient?
  end


end