class Folder < ActiveRecord::Base
  has_ancestry
  belongs_to :user
  has_many   :kudos, :class_name => "KudoCopy"
end
