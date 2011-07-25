module OurKudos
  module Helpers
    module Sanitization

      include ActionView::Helpers::SanitizeHelper
      include ActionView::Helpers::UrlHelper
      extend ActionView::Context

      def clean_up_links! column = :body
        self.send "#{column}=", strip_links(self.send(column)).gsub(RegularExpressions.protocol, '')
      end


    end
  end
end