module ApplicationHelper
  
  def error_messages_for object
    s = "<div class='error error_explanation red'>"
    object.errors.full_messages.uniq.each  do |error|
      s += "#{error}<br/>"
    end
    s << "</div>"
    object.errors.any? ? s.html_safe : nil.to_s
  end
  
  def sortable(column, title = nil)
    title ||= column.titleize
    
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, params.merge(:sort => column, :direction => direction, :page => nil), {:class => css_class}
  end

  def jquery_autocomplete(field_id, controller)
   "$(function(){" +
     "$('#"+ field_id + "').autocomplete( { source: '/#{controller}' }); " +
    "} );".html_safe
  end

  def admin_request?
    request.url.include?('/admin')
  end

  def admin_or_user_edit_identity_path(user, identity)
    return edit_user_identity_path(user, identity) unless admin_request?

    edit_admin_user_identity_path(user, identity)
  end

  def admin_or_user_identity_path(user, identity)
    return user_identity_path(user, identity) unless admin_request?
    
    admin_user_identity_path(user, identity)
  end




  
end
