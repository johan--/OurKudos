module OurKudos
  module Acts
    module Confirmable

     def self.included(base)
       base.extend AddActsAsConfirmable
     end

     
     module AddActsAsConfirmable
          def acts_as_confirmable(options = {})
            before_save :generate
            

            class_eval do
              include OurKudos::Acts::Confirmable::InstanceMethods
            end

          end
     end

     
     module InstanceMethods

       include OurKudos::Acts::Confirmable::KeyGenerator

       def self.included(aClass)
         aClass.extend ClassMethods
       end

       def confirm!
         self.update_attribute :confirmed, true
       end

       def confirmed?
         self.confirmed
       end


       module ClassMethods
        

         
       end

     end

   end
  end
end