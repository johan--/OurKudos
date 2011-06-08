class Admin::AdminController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  layout 'admin'
  
  def index
  end


  
end
