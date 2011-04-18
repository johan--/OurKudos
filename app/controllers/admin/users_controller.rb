class Admin::UsersController < ApplicationController
  respond_to :html, :js
  helper_method :sort_column, :sort_direction
  
  
  def index
    @users = User.page(params[:page]).per(params[:per_page]) 
    @users = @users.search params[:search] unless params[:search].blank?
    @users = @users.order "#{sort_column} #{sort_direction}"

  end
  
  
  private 
  
    def sort_column
      User.column_names.include?(params[:column]) ? (return params[:column]) : (return "email")
    end
    
    def sort_direction
      params[:direction] || "ASC"
    end
  
  
  
end
