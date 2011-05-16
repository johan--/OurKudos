module OurKudos
    module Confirmable     

      
      def generate key_length = 64
        return current_object.key unless current_object.key.blank?

        big_array = ('A'..'Z').to_a + ("a".."z").to_a + ("0".."9").to_a
        current_object.key = ''
        1.upto(key_length) { current_object.key << big_array[rand(big_array.size-1)] }
      end

      def regenerate!
        current_object.key = ''
        generate
        save :validate => false
      end

      def confirm!    
        current_object.update_attribute :confirmed, true
      end

      def current_object
        return self.confirmation if self.respond_to?(:confirmation)
        self
      end

      def save_confirmation        
        create_confirmation(:confirmable_type => self.class.name, 
                            :confirmable_id   => self.id,
                            :confirmed        => false) if needs_confirmation?
       
      end

      def needs_confirmation?
        self.respond_to?(:confirmation) && self.confirmation.blank?
      end

    end  
end