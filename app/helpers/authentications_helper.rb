module AuthenticationsHelper

def show_authentication_status(provider)
	auth = Authentication.find_by_provider(provider)
	if auth
		content_block = content_tag(:p, link_to(image_tag(provider+'_tile_icon.png', :class => "sn_tile_status")+ content_tag(:span ,provider.titleize, :class=>'sn_status'),"/authentications/#{auth.id.to_s}/delete" ))


	else
		content_block = content_tag(:p, link_to(image_tag(provider+'_tile_icon_dim.png', :class => "sn_tile_status")+ content_tag(:span, provider.titleize, :class=>'sn_status_dim'),"/auth/#{provider}"))


	end
	
	return content_block
end


end