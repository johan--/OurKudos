module ApplicationHelper
  
  def error_messages_for object
      s = "<div class='error red'>"
      object.errors.full_messages.uniq.each  do |error|
        s += "#{error}<br/>"
      end
      s << "</div>"
       object.errors.any? ? s.html_safe : nil.to_s
  end
  
  #with hidden field for unchecked values
  def improved_check_box_tag name, value = "1", checked = false, options = {}
    check_box_tag(name, value, checked, options) + text_field_tag(name, false, :type => :hidden)
  end
    
  
  
end
