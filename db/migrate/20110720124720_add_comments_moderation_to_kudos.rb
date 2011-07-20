class AddCommentsModerationToKudos < ActiveRecord::Migration
  def change
    add_column :kudos, :comments_moderation_enabled, :boolean, :default => true
  end
end
