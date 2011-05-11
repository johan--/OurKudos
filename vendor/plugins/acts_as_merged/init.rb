require 'acts_as_merged'
ActiveRecord::Base.send(:include, OurKudos::Acts::Merged)