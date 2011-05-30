module AuthenticationsHelper

  def show_authentication_status provider
    auth = current_user.send "#{provider}_auth"

    if auth.blank?
         klass   = 'sn_status_dim'
         method  = :post
         path    = omniauth_authorize_path(:user, provider)
         image   = image_tag(provider+'_tile_icon_dim.png', :class => "sn_tile_status")
     else
         klass   = 'sn_status'
         method  = :delete
         path    = user_authentication_path(current_user, auth)
         image   = image_tag(provider+'_tile_icon.png', :class => "sn_tile_status")

     end

      content_tag :p, do
        link_to (image + content_tag(:span ,provider.titleize, :class => klass)),
                path, :method => method
      end

  end


end