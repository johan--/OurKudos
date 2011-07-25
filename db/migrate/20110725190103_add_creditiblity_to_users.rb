class AddCreditiblityToUsers < ActiveRecord::Migration
  def change
    add_column :users, :credibility, :integer, :default => 0
  end
end
