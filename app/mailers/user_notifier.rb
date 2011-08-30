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
        @first_name = confirmation.confirmable.identity.user.first_name
        subject =  I18n.t(:subject_confirm_your_identity_for_merge_process)
      when :identity
        identity = confirmation.confirmable

        @email   = identity.user.current_recipient_for identity
        @first_name   = identity.user.current_first_name_for identity
        @account = identity.user.identities.size == 1

        subject  =  I18n.t('devise.mailer.confirmation_instructions.subject')
    end

    mail :to => @email, :subject => subject do |format|
      format.html { render template }
      format.text { render template }
    end
    
  end

  def kudo email_kudo
    @email  = email_kudo.email
    @author = email_kudo.kudo.author.first_name
    @kudo   = email_kudo
    @host   = host
    mail :to => @email, :subject => "#{@author} #{I18n.t(:new_kudo_in_your_inbox)}"
  end

  def system_kudo kudo_copy
    @kudo      = kudo_copy
    @recipient = kudo_copy.recipient
    @host      = host
    if @recipient.messaging_preference.system_kudo_email?
      mail :to => @recipient.email, :subject => "#{@kudo.kudo.author} #{I18n.t(:new_kudo_in_your_inbox)}"
    end
  end

  def password_changed user, password
    @user      = user
    @password  = password
    mail :to      => @user.email,
         :subject => I18n.t(:email_subject_your_password_has_been_successfuly_changed)
  end

  def kudo_moderate comment
    @comment = comment
    @author  = comment.user
    @kudo    = comment.commentable
    @user    = @kudo.author
    mail :to => @kudo.recipients_emails, :subject => I18n.t(:email_subject_kudo_comments_moderation)
  end

  def flag_abuse user
    @author = user
    mail :to => @author.email, :subject => "[OurKudos] - Administrator warning"
  end

  def you_are_banned user
    @user = user
    mail :to => @user.email, :subject => "[OurKudos] - You have been banned from OurKudos"
  end

  def receive email
    puts get_document_from email
  end


  private

    def get_document_from email
      if email.multipart? && system_kudo?(email)
        content = email.parts.select {|part| part.content_type.include?("text/html")}.first.body.to_s rescue ''
        document = Nokogiri::HTML content
        document.to_s
      end
    end

    def get_message_id_and_user_from document

    end

    def system_kudo? email
      email.subject.to_s.include? "sent you Kudos!"
    end



end
