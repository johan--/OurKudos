class AddConfigurationVariableSetting < ActiveRecord::Migration
  def self.up
    setting        = Settings[:sign_up_disabled]
    unless setting.blank?
      Settings.create :name => "sign-up-disabled", :value => "yes"
    end
  end

  def self.down
   Settings[:sign_up_disabled].destroy if !Settings[:sign_up_disabled].blank?
  end
end
