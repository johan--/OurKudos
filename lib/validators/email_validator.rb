class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors[attribute] << (options[:message] || "is invalid") unless value =~ RegularExpressions.email
    record.errors[attribute] << (options[:message]  || "has already been taken") if identity_email_exists?(record, value)
  end

  def identity_email_exists?(record, email)
    !(User.where(:email => email).where("id <> ?", record.id).blank?) || 
      search_identity_table(record, email)
  end

  def search_identity_table(record, email)
      return !(Identity.where(:identity => email, :identity_type => "email").
               where("user_id <> ?", record.id).blank?) unless record.new_record?

      return !(Identity.where(:identity => email, :identity_type => "email").blank?) if record.new_record?
  end

end
