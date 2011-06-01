module KudosHelper

  def kudos_current_class_for tab
     params[:kudos] == tab ? "active kdt_#{tab}" : ''
  end


end
