class CreateSites < ActiveRecord::Migration
  def self.up
    create_table :sites do |t|
      t.string :site_name, :url, :protocol
      t.text :description
      t.boolean :blocked, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :sites
  end
end
