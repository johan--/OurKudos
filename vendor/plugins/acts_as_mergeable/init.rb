require 'acts_as_mergeable'
ActiveRecord::Base.send :include, OurKudos::Acts::Mergeable