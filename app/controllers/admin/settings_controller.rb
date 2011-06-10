class Admin::SettingsController < ApplicationController

  def create
    @disable_social_sharing = Settings[:disable_social_sharing]
  end

  def update
    if Settings[params[:id]].update_attributes params[:settings]
      redirect_to admin_settings_path, :notice => "Website Options updated."
    else
      redirect_to admin_settings_path, :notice => "Website Options not updated."
    end
  end

end
