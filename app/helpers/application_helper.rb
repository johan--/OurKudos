module ApplicationHelper

  def error_messages_for object
    s = "<div class='error' id='error_explanation'>"
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

  def kudo_flag_path_user_info user
    link_to user.to_s + "(#{user.kudo_flags.size})", admin_user_path(user)
  end

  SETTINGS.each do |key, value|
     method = "#{key}?"
     define_method method do
       value == 'yes'
     end
   end

  def social_sharing_enabled?
    Settings[:social_sharing_enabled] == 'yes'
  end

  def profile_picture
    current_user.current_profile_picture
  end

  def profile_picture_for user
    image_tag(user.current_profile_picture, :class => 'avatar')
  end

  def anon_picture
    image_tag 'avatar_unknown.png', :class => 'avatar'
  end

  def spinner_tag
    image_tag 'spinner.gif', :id => "spinner", :style => "display:none", :width => 16, :height => 16
  end


  
end
