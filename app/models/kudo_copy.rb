class KudoCopy < ActiveRecord::Base

  belongs_to :kudo
  belongs_to :recipient, :class_name => "User"
  belongs_to :folder

  belongs_to :kudoable, :polymorphic => true
  delegate   :author, :created_at, :subject, :body, :recipients, :to => :kudo


  def copy_recipient
    return if my_kudo?
    return self.recipient.to_s if self.recipient
    self.temporary_recipient   if self.recipient.blank?
  end

  def my_kudo?
    self.recipient == self.author
  end
end
