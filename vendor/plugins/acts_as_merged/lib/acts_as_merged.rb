module OurKudos
  module Acts
    module Merged

     def self.models #gets list of models which are using our plugin
       @merged_models = []
        ActiveRecord::Base.connection.tables.each do |model|
          begin
            model_klass = model.singularize.capitalize.constantize
            @merged_models << model_klass if model_klass.respond_to?(:acts_as_merged)
          rescue Errno, Exception => e
            nil
          end
        end
        return @merged_models
     end 

     def self.included(base)
       base.extend AddActsAsMerged
     end

     
     module AddActsAsMerged
       def acts_as_merged(options = {})
          belongs_to :user

          class_eval <<-END
            include OurKudos::Acts::Merged::InstanceMethods
          END
       end


     end

     
     module InstanceMethods
     
       def self.included(aClass)
         aClass.extend ClassMethods
       end

       def change_owner_to new_user
         self.update_attribute :user_id, new_user.id
       end


       module ClassMethods

          def change_objects_owner_to objects, new_user
            objects.each {|object| object.change_owner_to new_user  }
          end
         
       end

     end

   end
  end
end