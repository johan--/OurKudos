require 'token_generator'
class Merge < ActiveRecord::Base

  belongs_to :merger, :foreign_key => :merged_by
  before_save :generate


  def set_as_confirmed!
    update_attribute
  end

  class << self

    def accounts old_user, new_user
      create :merged_by => new_user.id, :merged_with_email => old_user.email
    end

  end

end
