class RenameEditorToKudoEditor < ActiveRecord::Migration
  def up
    role = Role.find_by_name("editor")
    role.update_attribute(:name, "kudo editor") if role
  end

  def down
    role = Role.find_by_name("kudo editor")
    role.update_attribute(:name, "editor") if role
  end
end
