class Admin::SettingsController < ApplicationController
  before_filter :authenticate_user!
  layout "admin"

  def index
    @social_sharing_enabled = Settings[:social_sharing_enabled]
    @sign_up_disabled       = Settings[:sign_up_disabled]
    @special_message        = Settings[:test_environment_special_message]
  end

  def update
    @setting = Settings.find(params[:id])
    if @setting.update_attributes params[:settings]
      redirect_to admin_settings_path, :notice => "Website Options updated."
    else
      redirect_to admin_settings_path, :notice => "Website Options not updated."
    end
  end

end
