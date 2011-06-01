module KudosHelper

  def kudos_current_class_for_link tab
     return 'active' if tab == 'sent' && params[:kudos].blank?

     params[:kudos] == tab ? 'active' : ''
  end

  def kudos_current_class_for_tab
    return "kdt_sent" if params[:kudos].blank? || params[:kudos] == "sent"
    "kdt_#{params[:kudos]}"
  end

end