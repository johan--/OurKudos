class FirstIdentitiesController < ApplicationController
  before_filter :authenticate_user!

  def show
    @user     = User.find params[:user_id] rescue nil
    @identity = @user.primary_identity if @user
  end



end