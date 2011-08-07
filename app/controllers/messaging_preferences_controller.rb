class MessagingPreferencesController < ApplicationController
  before_filter :authenticate_user!
  layout 'registered'
  
  def edit
    @preference = MessagingPreference.find_by_user_id(current_user.id)
  end

  def update
    puts params.inspect
    @preference = MessagingPreference.find_by_user_id(current_user.id)
    if @preference.update_attributes(params[:messaging_preference])
      flash[:notice] = "Successfully updated messaging preferences"
      redirect_to user_path(current_user)
    else
      render :action => 'edit'
    end
  end

end
