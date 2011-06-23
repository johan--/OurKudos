class KudoFlag < ActiveRecord::Base

  belongs_to :flagger, :class_name => "User", :foreign_key => :flagger_id
  belongs_to :kudo_copy
  belongs_to :flaggable, :polymorphic => true, :class_name => "KudoFlag"

  class << self

    def reasons_for_select
      [
        ['Reason 1', 'Reason 1'],
        ['Reason 2', 'Reason 2'],
        ['Another reason', 'Another reason'],
        ['We will change that later', 'We will change that later']
      ]
    end


  end


end
