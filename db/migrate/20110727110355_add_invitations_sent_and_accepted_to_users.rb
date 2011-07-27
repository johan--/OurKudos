class AddInvitationsSentAndAcceptedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :invitations_sent,     :integer, :default => 0
    add_column :users, :invitations_accepted, :integer, :default => 0
  end
end
