class OauthController < ApplicationController

  
   before_filter :authenticate_user!, :except => [:access_token]
   skip_before_filter :verify_authenticity_token, :only => [:access_token]

   def authorize
     Permission.remove_old!
     permission = current_user.permissions.create :site => site
     redirect_to permission.redirect_uri_for params[:redirect_uri]
   end

   def access_token
      site = Site.authenticate params[:client_id], params[:client_secret]
      render :json => {:error => t(:could_not_find_application)} and return if site.blank?

      permission = Permission.authenticate params[:code], site.id
      render :json => {:error => t(:could_not_authenticate_access_code)} and return if permission.blank?


      permission.start_expiry_period!
      permission.user.set_new_token_to! permission.access_token
      
      render :json => {:access_token  => permission.access_token,
                       :refresh_token => permission.refresh_token,
                       :expires_in    => permission.access_token_expires_at }
   end

   def user
     respond_to do |format|
       
       format.json {
         render :json => current_user.as_json
       }
     end
   end


   private

      def site
        @site ||= Site.find_by_application_id params[:client_id]
      end


end
