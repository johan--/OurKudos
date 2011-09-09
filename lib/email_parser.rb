module EmailParser

    def get_user_from email
      link = get_link_element get_document_from(email)
      email = link.attributes['href'].to_s.split("recipient=").last.split("&").first

      Identity.find_by_identity(email).user
    rescue
      log_error "Cannot find such identity #{identity}"
    end

    def get_document_from email
      begin
        content = email.parts.select {|part| part.content_type.include?("text/html")}.first.body.to_s if process_incoming_email?(email)
        Nokogiri::HTML content
      rescue
        log_error "EMAIL_PARSER: Cannot find text/html email part"
      end
    end

    def get_link_element document
      document.xpath("//a").select {|el| el.attributes['href'].to_s =~ /kudo_id=\d{1,}$/ }.first
    end

    def get_message_id_from document
      begin
        element = get_link_element document
        id = element.attributes['href'].to_s.split("kudo_id=").last.to_i unless element.blank?
        KudoCopy.find(id).kudo if id > 0
      rescue
        log_error "EMAIL_PARSER: Cannot find message id in email or kudo with such id"
      end
    end

    def process_incoming_email?(email)
      email.multipart? && system_kudo?(email)
    end

    def cleanup_reply content
      content.gsub("notifications@ourkudos.com",'').gsub("<",'').gsub(">",'').gsub("wrote:","").strip
    end

    def get_content_from email
      begin
        document = get_documet_from email
        return cleanup_reply(document.xpath("//body").text.split(/please reply above this line/).first.gsub("-------- ",'').strip)

        #document.css("body//text()").text.strip.split("\n").first.strip
        #document.css("body").xpath("*/preceding-sibling::text()[1]").first.text.to_s.strip
      rescue
        log_error "EMAIL_PARSER: Cannot find reply content"
      end
    end

    def system_kudo? email
      email.subject.to_s.include? "sent you Kudos!"
    end

    def log_error message
      Rails.logger.error message
    end

    def reply_marker
      "-------- please reply above this line"
    end



end