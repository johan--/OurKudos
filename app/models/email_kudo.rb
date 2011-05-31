class EmailKudo < ActiveRecord::Base
  has_one :kudo,          :as => :kudoable
  has_on  :confirmations, :as => :confirmable
end
