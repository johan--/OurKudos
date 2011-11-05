class EmailValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    record.errors[attribute] << (options[:message]  || "is invalid") unless value =~ RegularExpressions.email

    if display_resend_error? value, record
      record.errors[:base] << (options[:message]      || I18n.t(:please_confirm_identity, :email => (record.email rescue record.identity), :host => host  ))
    else
      record.errors[attribute] << (options[:message]  || "has already been taken") if record.is_a?(User)     && identity_email_exists?(record, value)
      record.errors[attribute] << (options[:message]  || "has already been taken") if record.is_a?(Identity) && search_identity_table(value, record)
    end

    record.errors[:base] << I18n.t(:email_is_different_than_invitation_email, :email => record.email) if  sign_up_disabled? && consider_invitation_email?(record) && invalid_invitation_email?(record)
  end

  def identity_email_exists?(record, email)
    !(search_users_table(email, record)).blank?  || search_identity_table(email, record)
  end

  def search_identity_table(email, record)
      return !search_identities_table(email).where("(identifiable_id <> ? OR identifiable_type <> ?)", record.id, record.class.to_s).blank? unless record.new_record?

      !search_identities_table(email).blank? if record.new_record?
  end

  def host
    OurKudosMainSite::Application.config.action_mailer.default_url_options[:host]
  end

  def display_resend_error? email, record
    result = search_identities_table(email)
    !result.first.blank? && !result.first.primary_identity_confirmed?
  end

  def search_users_table email, record
     User.where(:email => email).where("id <> ?", record.id)
  end

  def search_identities_table email
     Identity.where(:identity => email, :identity_type => "email", :identifiable_type => 'User')
  end

  def consider_invitation_email?(record)
    record.is_a?(User) && record.new_record? && !record.consider_invitation_email.blank?
  end

  def invalid_invitation_email?(record)
    record.email != record.consider_invitation_email
  end

  def sign_up_disabled?
    SETTINGS[:sign_up_disabled] == "yes"
  end


end
