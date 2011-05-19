class CreateIps < ActiveRecord::Migration
  def self.up
    create_table :ips do |t|
      t.string :address
      t.boolean :blocked,         :default => false
      t.datetime :unlock_in,      :default => Time.now-100.years
      t.integer :failed_attempts, :default => 0
      t.datetime :last_seen

      t.timestamps
    end
  end

  def self.down
    drop_table :ips
  end
end
