class ProfilesController < ApplicationController


  layout 'unregistered'

  def show
    redirect_to home_path if user_signed_in?

    @user = User.find params[:user_id]
    get_public_kudos
  end

  private

    def get_public_kudos
      %w{received sent}.include?(params[:kudos]) ?
          term = params[:kudos] : term = "newsfeed"

      @kudos = @user.send("#{term}_kudos").page(params[:page]).per(10)
      @kudos = Kudo.public_kudos.limit(10)         if term == 'received' && @kudos.blank?
      @kudos = @kudos.order("kudos.id DESC")       if @kudos.respond_to?(:order) && @kudos.first.is_a?(Kudo)
      @kudos = @kudos.order("kudo_copies.id DESC") if @kudos.respond_to?(:order) && @kudos.first.is_a?(KudoCopy)
  end


end
