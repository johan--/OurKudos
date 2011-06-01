class EmailKudo < ActiveRecord::Base
  has_one :kudo,           :as => :kudoable,    :dependent => :destroy
  has_one  :confirmations, :as => :confirmable, :dependent => :destroy
end
