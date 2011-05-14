module OurKudos
    module Confirmable     

      
      def generate key_length = 64
        return polymorphic_or_self.key unless polymorphic_or_self.key.blank?

        big_array = ('A'..'Z').to_a + ("a".."z").to_a + ("0".."9").to_a
        polymorphic_or_self.key = ''
        1.upto(key_length) { polymorphic_or_self.key << big_array[rand(big_array.size-1)] }
      end

      def regenerate!
        polymorphic_or_self.key = ''
        generate
        save :validate => false
      end

      def confirm!    
        update_attribute :confirmed, true if self.respond_to?(:confirmed)
      end

      def polymorphic_or_self
        return self.confirmation if needs_confirmation?
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