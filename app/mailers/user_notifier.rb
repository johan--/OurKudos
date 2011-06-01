class UserNotifier < ActionMailer::Base
  default :from => "do-not-reply@ourkudos.com"

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
    mail :to => @email, :subject => I18n.t(:someone_says_thank_you_to_you)
  end


end
