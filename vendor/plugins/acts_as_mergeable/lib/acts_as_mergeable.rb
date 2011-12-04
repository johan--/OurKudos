module OurKudos
  module Acts
    module Mergeable

     def self.mergeables
       @mergeable = []
        ActiveRecord::Base.connection.tables.each do |model|
          begin
            mergeable_model = model.classify.constantize           
            @mergeable << mergeable_model if mergeable_model.is_mergeable?
          rescue Errno, Exception => e
            nil
          end
        end
      @mergeable
     end

     def self.included(base)
       base.extend AddActsAsMergeable
     end

     
     module AddActsAsMergeable
          def acts_as_mergeable(options = {})
            belongs_to :user
            scope :for_auth,   ->(user) { where(:user_id => user.id) }
            scope :for_identity,   ->(user) { where(:identifiable_id => user.id) }

            class_eval <<-END
              include OurKudos::Acts::Mergeable::InstanceMethods
            END
          end

          def is_mergeable?
            instance_methods.include?(:change_owner_to)
          end


     end

     
     module InstanceMethods
     
       def self.included(aClass)
         aClass.extend ClassMethods
       end

       def change_owner_to new_user
         self.update_attribute :identifiable_id, new_user.id
       end


       module ClassMethods

          def change_objects_owner_to objects, new_user
            objects.each {|object| object.change_owner_to new_user } 
          end
         
       end

     end

   end
  end
end
