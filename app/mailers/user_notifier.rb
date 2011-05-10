class UserNotifier < ActionMailer::Base
  default :from => "do-not-reply@ourkudos.com"

  def confirm_your_identity_for_merge_process user
    @user = user
    mail :to => user.email,:subject => I18n.t(:confirm_your_identity_for_merge_process)
  end


end
