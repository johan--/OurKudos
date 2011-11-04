require 'email_parser'
class UserNotifier < ActionMailer::Base
  default :from => "do-not-reply@ourkudos.com"
  include EmailParser

  def host
    "http://#{OurKudosMainSite::Application.config.action_mailer.default_url_options[:host]}"
  end

  def confirmation confirmation, type = :merge
    @confirmation = confirmation
    template      =  "#{confirmation.confirmable_klass_type}_confirmation"
    case type
      when :merge
        @email      = confirmation.confirmable.identity.identifiable.email
        @first_name = confirmation.confirmable.identity.identifiable.first_name
        subject     = I18n.t(:subject_confirm_your_identity_for_merge_process)
      when :virtual_merge
        @email      = confirmation.confirmable.identity.identifiable.email
        @first_name = confirmation.confirmable.identity.identifiable.first_name
        subject     = I18n.t(:subject_confirm_your_identity_for_merge_process)
      when :identity
        identity = confirmation.confirmable
        user     = identity.user

        @email        = user.email
        @first_name   = user.first_or_company_name
        @account      = user.identities.size == 1

        subject  =  I18n.t('devise.mailer.confirmation_instructions.subject')
    end

    mail :to => @email, :bcc => "ted@ourkudos.com", :subject => subject do |format|
    #mail :to => @email, :subject => subject do |format|
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
    unless @kudo.recipient_type == 'VirtualUser' 
      if @recipient.messaging_preference.system_kudo_email?
        mail :to => @recipient.email, :subject => "#{@kudo.kudo.author} #{I18n.t(:new_kudo_in_your_inbox)}"
      end
    end
  end

  def social_system_kudo kudo, recipient
    @kudo      = kudo
    @recipient = recipient
    @host      = host
    if @recipient.is_a?(User) && @recipient.messaging_preference.system_kudo_email?
      mail :to => @recipient.email, :subject => "#{@kudo.author} #{I18n.t(:new_kudo_in_your_inbox)}"
    end
  end

  def password_changed user, password
    @user      = user
    @password  = password
    mail :to      => @user.email,
         :subject => I18n.t(:email_subject_your_password_has_been_successfuly_changed)
  end

  def kudo_moderate comment, email
    @comment = comment
    @author  = comment.user
    @email   = email
    @kudo    = comment.commentable
    @user    = @kudo.author
    mail :to => @email, :subject => I18n.t(:email_subject_kudo_comments_moderation)
  end

  def flag_abuse user
    @author = user
    mail :to => @author.email, :subject => t(:email_subject_administrator_warning)
  end

  def you_are_banned user
    @user = user
    mail :to => @user.email, :subject => t(:email_subject_you_have_been_banned)
  end

  def receive email
    if system_kudo?(email) && email.multipart?
        Comment.reply_as_user_to_kudo(get_user_from(email), get_message_id_from(get_document_from(email)), get_content_from(email)) rescue nil
    end
  end

  def login_failure_notify_admin(subject, username, ip, user_agent)
    @user = username
    @ip = ip
    @user_agent = user_agent
    mail :to => 'charley.stran@gmail.com, ted@ourkudos.com', :subject => t(:email_subject_failed_login, :subject => subject)
  end

  def login_failure_notify_user(user, ip_address)
    @user = user
    @ip_address = ip_address
    mail :to => @user.email, :subject => t(:email_subject_failed_login_attempt)
  end

end
