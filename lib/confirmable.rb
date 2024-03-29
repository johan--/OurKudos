module OurKudos
    module Confirmable     
      
      def generate key_length = 64
        return current_object.key unless current_object.key.blank?      
        current_object.key = (Devise.friendly_token*4)[0..key_length-1]
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
        return true if self.is_a?(Confirmation) && self.confirmable_type == "Identity"
        create_confirmation(:confirmable_type => self.class.name, 
                            :confirmable_id   => self.id,
                            :confirmed        => already_confirmed?) if needs_confirmation?

      end

      def already_confirmed?
        (self.is_a?(Identity) && Rails.env == 'test') ||
            (self.respond_to?(:confirmable) && confirmable.is_a?(Identity) && confirmable.is_twitter?) ||
            (self.is_a?(Identity) && !self.no_confirmation.blank?)
      end

      def needs_confirmation?
        self.respond_to?(:confirmation) && self.confirmation.blank?
      end

      def resend!
        self.confirmed = false
        self.save :validate => false
      end

    end

end
