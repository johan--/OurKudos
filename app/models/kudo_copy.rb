class KudoCopy < ActiveRecord::Base

  belongs_to :kudo
  belongs_to :recipient, :class_name => "User"
  belongs_to :folder

  delegate   :author, :created_at, :subject, :body, :recipients, :to => :kudo

end
