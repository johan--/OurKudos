class KudoFlag < ActiveRecord::Base

  belongs_to :flagger, :class_name => "User", :foreign_key => :flagger_id
  belongs_to :flagged_kudo, :class_name => "Kudo", :foreign_key => "kudo_id"

  attr_accessor :ui_message

  validates :flag_reason, :presence => true

  after_save  :process_archivization, :on => :update

  scope :for_management, Proc.new {|order, direction|
                                          joins(:flagged_kudo).joins(:flagger).
                                          order("#{order} #{direction}").
                                          where(:flag_valid => nil) }

  scope :valid, where(:valid => true)


  def process_flagging
    recipients = flagged_kudo.people_received_ids.sort
    flagged_kudo.flaggers << flagger.id

    if !recipients.include?(flagger.id)
      add_flagger
    else
      recipients_flagging recipients
    end
  end

  def recipients_flagging recipients
    if all_recipients_flagged? recipients
      all_recipients_flagged!
    else
      one_recipient_flagged!
    end
  end

  def all_recipients_flagged? recipients
   flagged_kudo.all_recipients_are_flaggers? ||  recipients == [flagger.id]
  end

  def all_recipients_flagged!

    self.ui_message = I18n.t(:kudo_marked_as_offensive_by_all_recipients)
    flagged_kudo.archivize
    self.flagged_kudo.destroy && destroy
  end

  def add_flagger
    flagged_kudo.add_to_my_flaggers flagger, true
    self.ui_message = I18n.t(:kudo_has_been_flagged)
  end

  def one_recipient_flagged!
    flagged_kudo.set_me_and_my_copies_scope_to :recipients, flagger
    self.ui_message = I18n.t(:kudo_has_been_flagged)
  end

  def accept_flag!
    update_attribute :flag_valid, true
  end

  def reject_flag!
    update_attribute :flag_valid, false
  end

  def process_archivization
      if self.flag_valid == true
        flagged_kudo.archivize
        flagged_kudo.destroy
      elsif self.flag_valid == false
        flagged_kudo.improperly_flagged!
      end
  end


  class << self

    def reasons_for_select
      [
        ['Reason 1', 'Reason 1'],
        ['Reason 2', 'Reason 2'],
        ['Another reason', 'Another reason'],
        ['We wdoill change that later', 'We will change that later']
      ]
    end


  end


end

