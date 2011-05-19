class IsForbiddenPasswordValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    record.errors[:base] << (options[:message] || I18n.t('activerecord.errors.models.forbidden_password.attributes.password.forbidden')) if exists? value
  end

  def exists? password
    ForbiddenPassword.exists?(password.downcase) rescue false
  end


end
