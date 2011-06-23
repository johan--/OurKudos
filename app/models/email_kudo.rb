class EmailKudo < ActiveRecord::Base
  include OurKudos::Confirmable

  has_one :kudo, :class_name => "KudoCopy", :as => :kudoable

  before_save :generate

  scope :date_range, ->(from, to) { where(:created_at => from..to) }

  def viewable_by_recipient? email, kudo_id
    email == self.email  && kudo_id == self.key
  end

end
