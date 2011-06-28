class AddPenaltyScoreToUsers < ActiveRecord::Migration
  def change
    add_column :users, :penalty_score, :integer, :default => 0
  end
end
