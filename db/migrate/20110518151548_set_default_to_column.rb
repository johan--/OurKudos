class SetDefaultToColumn < ActiveRecord::Migration
  def self.up
    execute "alter table users alter column unlock_in set default '#{(Time.now-100.years).utc.to_s(:db)}'"
  end

  def self.down
  end
end
