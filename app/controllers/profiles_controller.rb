class ProfilesController < ApplicationController


  layout :choose_layout

  def show

    @user = User.find params[:user_id]
    get_member_kudos
  end

  private

    def get_member_kudos

      @kudos = @user.send("received_kudos") + @user.send("sent_kudos")
      @kudos = @kudos.order("kudos.created_at DESC")       if @kudos.respond_to?(:order) && @kudos.first.is_a?(Kudo)
      @kudos = @kudos.order("kudo_copies.updated_at DESC") if @kudos.respond_to?(:order) && @kudos.first.is_a?(KudoCopy)
  end


end
