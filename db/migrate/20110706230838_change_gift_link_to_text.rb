class ChangeGiftLinkToText < ActiveRecord::Migration
  def up
    change_column :gifts, :link, :text
  end

  def down
    change_column :gifts, :link, :string
  end
end
