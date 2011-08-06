class KudoFlagAction < ActiveRecord::Base
  belongs_to :kudo_flag
  belongs_to :admin_user,   :class_name => "User"

  validates_presence_of :action_taken
  ###Constants###
  ACTIONS = [ ['No Action', 'no_action'],
              ['Suspend User','suspend'],
              ['Delete User', 'delete'],
              ['Message Author', 'message_author'],
              ['Message Recipients', 'message_recipients']]
  ###############

  def self.process_flag_action params
    actions = params.collect{|p| p[1]['action']}
    no_action = true
    params.each do |param|
  
      unless param[1]['action'] == 'no_action' 
        no_action = false
        action = KudoFlagAction.new(:kudo_flag_id => param[1]['kudo_flag'].to_i,
                                    :admin_user_id => param[1]['current_user'].to_i,
                                    :action_taken => param[1]['action'] )
        action.save
      end

    end
    no_action
  end

end
