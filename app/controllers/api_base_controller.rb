require 'authorized_filter'
class ApiBaseController < ActionController::Base
  
  attr_accessor :current_user
  prepend_around_filter ApiAuthorizedFilter.new
  
  
end
