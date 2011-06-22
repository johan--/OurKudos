class EmailKudo < ActiveRecord::Base
  has_one :kudo, :class_name => "KudoCopy", :as => :kudoable

  scope :date_range, ->(from, to) { where(:created_at => from..to) }

  def viewable_by_recipient? email, kudo_id
    email == self.email  && kudo_id.to_i == self.id
  end

end
