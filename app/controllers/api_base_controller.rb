class ApiBaseController < ActionController::Base
  
  respond_to :json
  
  attr_accessor :current_api
  around_filter :authenticate_and_logout
  
  #rescue_from ActiveRecord::RecordNotFound,     :with => :no_record
  #rescue_from AbstractController::ActionNotFound, :with => :no_resource
  #rescue_from ActionController::RoutingError,     :with => :no_resource
  
  
  include OurKudos::Controllers::ApiHelper

  
end
