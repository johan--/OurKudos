class AddCommentsCountToKudos < ActiveRecord::Migration
  def change
    add_column :kudos, :comments_count, :integer, :default => 0
  end
end
