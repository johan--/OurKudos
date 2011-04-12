require 'client/our_kudos'
require 'client/response_codes'
class Api::UsersController < ApiBaseController
  
  respond_to :json
  
  def create
    @user = User.new params[:user]
    respond_with @user, :location => api_users_url do
      if @user.save
        render :json => [:message => OurKudos::ResponseCodes[:I1] ].to_json and return
      else
        render :json => [:message => OurKudos::ResponseCodes[:E1], :errors => @user.errors.to_json ].to_json and return
      end
    end
  end
  
end
