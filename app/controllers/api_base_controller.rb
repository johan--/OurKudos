require 'authorized_filter'
class ApiBaseController < ActionController::Base
  layout false
  
  attr_accessor :current_user
  prepend_around_filter AuthorizedFilter.new
  
  
end
