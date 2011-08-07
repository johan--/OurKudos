class AddWeeklyLocalSummaryToMessagingPreferences < ActiveRecord::Migration
  def change
    add_column :messaging_preferences, :weekly_local_summary, :boolean, :default => true
  end
end
