class KudoFlag < ActiveRecord::Base

  belongs_to :flagger, :class_name => "User", :foreign_key => :flagger_id
  belongs_to :kudo

  attr_accessor :ui_message

  validates :flag_reason, :presence => true
  after_save :process_flagging

  def process_flagging
    recipients = kudo.people_received_ids

    if !recipients.include?(flagger.id)
      add_flagger
    else
       if all_recipients_flagged?(recipients)
        all_recipients_flagged!
       else
        one_recipient_flagged!
       end
    end
  end

  def all_recipients_flagged? recipients
    recipients == [flagger.id] || kudo.all_recipients_are_flaggers?
  end

  def all_recipients_flagged!
    self.kudo.destroy
    self.ui_message = I18n.t(:kudo_marked_as_offensive_by_all_recipients)
    destroy
  end

  def add_flagger
    kudo.add_to_my_flaggers flagger, true
    self.ui_message = I18n.t(:kudo_has_been_flagged)
  end

  def one_recipient_flagged!
    kudo.set_me_and_my_copies_scope_to :recipient, flagger
    self.ui_message = I18n.t(:kudo_has_been_flagged)
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

