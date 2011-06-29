class Admin::SettingsController < ApplicationController

  layout "admin"

  def index
    @social_sharing_enabled = Settings[:social_sharing_enabled]
    @sign_up_disabled       = Settings[:sign_up_disabled]
  end

  def update
    if Settings[params[:id]].update_attributes params[:settings]
      redirect_to admin_settings_path, :notice => "Website Options updated."
    else
      redirect_to admin_settings_path, :notice => "Website Options not updated."
    end
  end

end
