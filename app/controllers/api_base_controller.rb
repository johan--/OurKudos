class ApiBaseController < ActionController::Base
  
  respond_to :json
  
  attr_accessor :current_api
  around_filter :authenticate_and_logout
  
  rescue_from ActiveRecord::RecordNotFound,     :with => :no_record
  rescue_from AbstractController::ActionNotFound, :with => :no_resource 
  rescue_from ActionController::RoutingError,     :with => :no_resource
  
  
  # this is called before every API action, user is authenticatied - yield - calls the contro.ller action, and log outs user 
  def authenticate_and_logout
    begin
      current_api = ApiKey.find_by_key params[:api_key]
    
      return authorization_response(1) if current_api.blank? #no user with such api key
      return authorization_response(2) if current_api.expired? #api key invalid/expired
      return authorization_response(3) if current_api.site.blocked?  #api key valid, but the site was blocked, stop action
    
      yield #here is the controller action
    
      current_api = nil #log out user
    rescue Errno, Exception => e
      respond_with_json_code :E5
    end
  end
  
  def authorization_response response_code
     render :json => [:message => OurKudos::ResponseCodes["E#{response_code.to_s}".to_sym], 
                      :code   => ":E#{response_code.to_s}".to_sym ].to_json
     false
  end
  
  def respond_with_code code_number
    OurKudos::ResponseCodes[code_number.to_sym]
  end
  
  # same as above but already as json
  def respond_with_json_code code_number
    render :json => [:message => OurKudos::ResponseCodes[code_number.to_sym], :code => code_number.to_sym ]
  end
  
  def no_record
    respond_with_json_code :E8
  end
  
  def no_resource
    respond_with_json_code :E9
  end
  
end
