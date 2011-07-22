class Admin::ApiKeysController < Admin::AdminController
  before_filter :authenticate_user!
  load_and_authorize_resource

  def new
    @site = Site.find params[:site_id]
    @site.api_keys.create
    redirect_to :back, :notice => t(:key_has_been_added)
  end
  
  def update
    @api_key = ApiKey.find params[:id]
    do_subaction
    redirect_to :back, :notice => t(:key_has_been_updated)
  end
  
    private 
      
    def do_subaction
      case params[:subaction]
        when 'regenerate'; @api_key.regenerate!
        when 'disable'   ; @api_key.set_as_expired!    
        when 'enable'    ; @api_key.set_as_valid!
        when 'remove'    ; @api_key.destroy
      end
    end

  
end
