class UserNotifier < ActionMailer::Base
  default :from => "do-not-reply@ourkudos.com"

  def confirm_your_identity_for_merge_process merge
    @merge = merge
    @user  = merge.merger
    mail :to => merge.identity.user.email,:subject => I18n.t(:subject_confirm_your_identity_for_merge_process)
  end


end
