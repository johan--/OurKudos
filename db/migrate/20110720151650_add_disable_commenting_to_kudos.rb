class AddDisableCommentingToKudos < ActiveRecord::Migration
  def change
    add_column :kudos, :comments_disabled, :boolean, :default => false
  end
end
