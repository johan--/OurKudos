require 'active_record'
require File.expand_path('../../lib/acts_as_mergeable', __FILE__)

ActiveRecord::Base.send(:include, OurKudos::Acts::Mergeable)

class MergeableModel < ActiveRecord::Base

  acts_as_mergeable
end

class NotMergeableModel < ActiveRecord::Base

end

class User < ActiveRecord::Base

  has_many :mergeable_models
end
