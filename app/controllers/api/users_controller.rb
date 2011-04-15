require 'client/our_kudos'
require 'client/response_codes'
class Api::UsersController < ApiBaseController

  respond_to :json
  
  def create
    @user = User.new params[:user]
    ActiveRecord::Base.logger.info current_api.key.to_s
    respond_with @user, :location => api_users_url do
      if @user.save
        render :json => [:message => OurKudos::ResponseCodes[:I1] ].to_json and return
      else
        render :json => [:message => OurKudos::ResponseCodes[:E4], :errors => @user.errors ].to_json and return
      end
    end
  end
  
  def index
    @users = User.all
    respond_with @users, :location => api_users_url
  end
  
  def show
    @users = User.all
    respond_with @users, :location => api_users_url
  end
    
  
end
