class UserNotifier < ActionMailer::Base
  default :from => "do-not-reply@ourkudos.com"


  def host
    "http://#{OurKudosMainSite::Application.config.action_mailer.default_url_options[:host]}"
  end

  def confirmation confirmation, type = :merge
    @confirmation = confirmation
    template      =  "#{confirmation.confirmable_klass_type}_confirmation"
    case type
      when :merge
        @email   = confirmation.confirmable.identity.user.email

        subject =  I18n.t(:subject_confirm_your_identity_for_merge_process)
      when :identity
        identity = confirmation.confirmable

        @email   = identity.user.current_recipient_for identity
        @account = identity.user.identities.size == 1

        subject  =  I18n.t('devise.mailer.confirmation_instructions.subject')
    end

    mail :to => @email, :subject => subject do |format|
      format.html { render template }
    end
    
  end

  def kudo email_kudo
    @email  = email_kudo.email
    @author = email_kudo.kudo.author.to_s
    @kudo   = email_kudo
    @host   = host
    mail :to => @email, :subject => I18n.t(:someone_says_thank_you_to_you)
  end

  def system_kudo kudo_copy
    @kudo      = kudo_copy
    @recipient = kudo_copy.recipient
    @host      = host
    mail :to => @recipient.email, :subject => I18n.t(:new_kudo_in_your_inbox)
  end

  def password_changed user, password
    @user      = user
    @password  = password
    mail :to => @user.email, :subject => I18n.t(:email_subject_your_password_has_been_successfuly_changed)
  end


end
