require 'api/base'
class ApiBaseController < ActionController::Base
  before_filter :authenticate_user!
  
  respond_to :json    
 
  
  include OurKudos::Api::Controllers::ServerBase

  
end
