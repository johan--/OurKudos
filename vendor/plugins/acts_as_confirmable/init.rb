require 'key_generator'
require 'acts_as_confirmable'

ActiveRecord::Base.send(:include, OurKudos::Acts::Confirmable)