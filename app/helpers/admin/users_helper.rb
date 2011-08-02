module Admin::UsersHelper

  def admin_user_remove_link user
      return link_to t(:user_remove), admin_user_path(user), :method => :delete, :confirm => I18n.t(:are_you_sure) if current_user != user
      t :current_account
  end

end
