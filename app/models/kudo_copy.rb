class KudoCopy < ActiveRecord::Base

  belongs_to :kudo
  belongs_to :recipient, :class_name => "User"
  belongs_to :folder

  delegate   :author, :created_at, :subject, :body, :recipients, :to => :kudo


  def copy_recipient
    return self.recipient     if self.recipient
    self.temporary_recipieint if self.recipient.blank?
  end
end
