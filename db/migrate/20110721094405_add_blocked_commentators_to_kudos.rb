class AddBlockedCommentatorsToKudos < ActiveRecord::Migration
  def change
    add_column :kudos, :blocked_commentators, :string, :default => [].to_yaml
  end
end
