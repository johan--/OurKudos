require 'api/base'
class ApiBaseController < ActionController::Base
  
  respond_to :json    
  #rescue_from ActiveRecord::RecordNotFound,     :with => :no_record
  #rescue_from AbstractController::ActionNotFound, :with => :no_resource
  #rescue_from ActionController::RoutingError,     :with => :no_resource
  
  
  include OurKudos::Api::Controllers::Base

  
end
