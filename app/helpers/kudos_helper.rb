module KudosHelper

  def kudos_current_class_for_link tab
     return 'active' if tab == 'newsfeed' && params[:kudos].blank?

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

end