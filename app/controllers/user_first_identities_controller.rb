class UserFirstIdentitiesController < ApplicationController
  before_filter :authenticate_user!
    respond_to :js

  def show
    @user = User.find params[:user_id]
    respond_with @user do |format|
      format.js { render :json => { :id => @identity.id, :name => @identity.identity } }
    end
  end

end
