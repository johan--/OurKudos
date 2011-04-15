class ApiBaseController < ActionController::Base
  layout false
  
  attr_accessor :current_api
  around_filter :authenticate_and_logout
  
  # this is called before every API action, user is authenticatied - yield - calls the contro.ller action, and log outs user 
  def authenticate_and_logout
    current_api = ApiKey.find_by_key params[:api_key] 
    
    return authorization_response(1) if current_api.blank? #no user with such api key
    return authorization_response(2) if current_api.expired? #api key invalid/expired
    return authorization_response(3) if current_api.site.blocked?  #api key valid, but the site was blocked, stop action
    
    yield #here is the controller action
    
    current_api = nil #log out user
    
  end
  
  def authorization_response response_code
     render :json => [:message => OurKudos::ResponseCodes["E#{response_code.to_s}".to_sym], :code => ":E#{response_code.to_s}".to_sym ].to_json
     false
  end
  
  def respond_with_code code_number
    OurKudos::ResponseCodes[code_number.to_sym]
  end
  
  
end
