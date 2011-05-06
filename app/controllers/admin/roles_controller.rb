class Admin::RolesController < ApplicationController
  
  before_filter :authenticate_user!

  def index
    @role = Role.scoped
  end

end
