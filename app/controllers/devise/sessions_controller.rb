class Devise::SessionsController < ApplicationController
  prepend_before_filter :require_no_authentication, :only => [ :new, :create ]
  include Devise::Controllers::InternalHelpers
   
    def new 
      sign_out_all_scopes_for_good if user_signed_in?
    end 
    
    def create 
      user = User.find_by_email params[:user][:email] rescue nil
      user_resource_name = user.nil? ? :user : user.resource_type
      params[user_resource_name] = params.delete :user
      if user.nil?
        redirect_to :back, :notice => I18n.t("devise.errors.messages.no_such_user")
      elsif user && user.encrypted_password.blank?
        redirect_to :back, :notice => I18n.t("devise.errors.messages.no_password")
      else  
        resource = warden.authenticate!(:scope => resource_name, :recall  => "#{controller_path}#new")       
        set_flash_message(:notice, :signed_in) if is_navigational_format? 
        sign_in(resource_name, resource) 
        respond_with resource, :location => redirect_location(resource_name, resource) 
      end  
    end 
    
    def destroy 
      signed_in = signed_in?(resource_name)
      sign_out_and_redirect(resource_name)
      set_flash_message :notice, :signed_out if signed_in
    end 
    
end