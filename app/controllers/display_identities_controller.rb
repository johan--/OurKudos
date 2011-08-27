class DisplayIdentitiesController < ApplicationController
  before_filter :authenticate_user!
  layout 'registered'

  def edit
    @identities = current_user.identities
  end

  def update
    if Identity.update_display_identity(current_user, params[:display_identity].to_i)
      flash[:notice] = t(:display_account_updated)
      redirect_to user_path(current_user)
    else
      flash[:error] = t(:there_was_a_problem_please_try_again)
      redirect_to edit_display_identity_path(current_user)
    end
  end
end
