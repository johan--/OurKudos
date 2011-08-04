class KudoFlagAction < ActiveRecord::Base
  belongs_to :kudo_flag
  belongs_to :admin_user,   :class_name => "User"

  ###Constants###
  ACTIONS = [ ['Suspend User','suspend'],
              ['Delete User', 'delete'],
              ['Message Author', 'message_author'],
              ['Message Recipients', 'message_recipients']]
  ###############
end
