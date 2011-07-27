class Admin::AdminController < ApplicationController
  before_filter :authenticate_user!, :check_index_permissions


  layout 'admin'
  
  def index
  end

  private

    def check_index_permissions
      redirect_to root_path if current_user.blank?
      redirect_to(home_url) unless current_user.has_role?(:admin) ||
            current_user.has_role?(:editor) ||
              current_user.has_role?("gift editor")
    end


  
end
