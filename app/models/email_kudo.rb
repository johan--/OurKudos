class EmailKudo < ActiveRecord::Base
  has_one :kudo, :class_name => "KudoCopy", :as => :kudoable

  scope :date_range, ->(from, to) { where(:created_at => from..to) }
end
