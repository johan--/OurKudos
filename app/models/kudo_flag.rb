class KudoFlag < ActiveRecord::Base
  belongs_to :flagger, :class_name => "User", :foreign_key => :flagger_id
  belongs_to :kudo_copy
end
