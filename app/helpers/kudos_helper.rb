module KudosHelper

  def kudos_current_class_for_link tab
     return 'active' if (tab == 'newsfeed' && params[:kudos].blank?)

     params[:kudos] == tab ? 'active' : ''
  end

  def kudos_current_class_for_tab
    return "kdt_newsfeed" if params[:kudos].blank? || params[:kudos] == "newsfeed"
    "kdt_#{params[:kudos]}"
  end

  def kudo_object kudo
    return kudo.kudo if kudo.is_a?(KudoCopy)
    kudo
  end

  def sent_kudo_destroy_link kudo
    if kudo.can_be_deleted_by?(current_user)
      link_to('', destroy_sent_user_kudo_path(current_user, kudo),
                                :method => :delete,
                                :confirm => I18n.t(:are_you_sure),
                                :class => "delete_kudo_btn")
      else     #just hide that kudo, cannot be deleted by non-author
      link_to('', hide_user_kudo_path(current_user, kudo),
                                :method => :delete,
                                :confirm => I18n.t(:are_you_sure),
                                :class => "delete_kudo_btn")
     end
  end

  def recipients_profiles kudo_recipients
    html = kudo_recipients.map do |recipient|
      link_to recipient.first, user_profile_path(recipient.last)
    end.join(", ")
    return html.html_safe unless html.empty?
    "undisclosed recipient(s)"
  end

  def kudo_author_picture kudo
    return  profile_picture_for(kudo.author) if kudo.author
    anon_picture
  end

  def last_sent_with_twitter?
    cookies["last_sent_with_twitter"] == "yes"
  end

  def last_sent_with_facebook?
    cookies["last_sent_with_facebook"] == "yes"
  end

  def shared_with scope
    case scope
    when "friends"
      "friends only"
    when "recipient"
      "recipient only"
    else
      "the world"
    end
  end

  def open_graphic_title kudo
    if kudo.recipients.size > 1 
      "#{kudo.author} sent Kudos to #{kudo.recipients.first.to_s} and others"
    else
      "#{kudo.author} sent Kudos to #{kudo.recipients.first.to_s}"
    end
  end

end
