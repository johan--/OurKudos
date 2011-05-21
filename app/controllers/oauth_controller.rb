class OauthController < ApplicationController
   before_filter :authenticate_user!, :except => [:access_token]
   skip_before_filter :verify_authenticity_token, :only => [:access_token, :user]

   def authorize
     Permission.remove_old!
     permission = current_user.permissions.create :site => site
     redirect_to permission.redirect_uri_for params[:redirect_uri]
   end

   def access_token
      site = Site.authenticate params[:client_id], params[:client_secret]
      render :json => {:error => "Could not find application"} and return if site.blank?

      permission = Permission.authenticate params[:code], site.id
      render :json => {:error => "Could not authenticate access code"} and return if permission.blank?


      permission.start_expiry_period!
      render :json => {:access_token  => permission.access_token,
                       :refresh_token => permission.refresh_token,
                       :expires_in    => permission.access_token_expires_at }
   end

   def user
     render :json => current_user.as_json
   end


   private

      def site
        @site ||= Site.find_by_application_id params[:client_id]
      end


end
