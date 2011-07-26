module OurKudos
  module Helpers
    module Sanitization

      include ActionView::Helpers::SanitizeHelper::ClassMethods

      def clean_up_links! column = :body
        self.send "#{column}=",
                  link_sanitizer.sanitize(self.send(column)).gsub(RegularExpressions.protocol, '')
      end


    end
  end
end