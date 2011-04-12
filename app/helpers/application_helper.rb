module ApplicationHelper
  
  def error_messages_for object
      s = "<div class='error red'>"
      object.errors.full_messages.uniq.each  do |error|
        s += "#{error}<br/>"
      end
      s << "</div>"
       object.errors.any? ? s.html_safe : nil.to_s
    end
  
  
end
