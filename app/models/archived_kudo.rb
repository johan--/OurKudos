class ArchivedKudo < ActiveRecord::Base
  belongs_to :author,   :class_name => "User"
  belongs_to :kudo_category

  serialize :flaggers

  attr_accessible :flaggers,  :subject, :body, :to, :share_scope,
                  :facebook_sharing, :twitter_sharing, :kudo_category_id,
                  :author_id, :created_at, :updated_at, :removed

  def users_who_flagged_me
    @users ||= flaggers.map do |id|
      User.find id.to_i rescue nil
    end.compact.flatten
  end

end