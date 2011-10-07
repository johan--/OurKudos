class ProfilesController < ApplicationController


  layout :choose_layout

  def show

    @user = User.find params[:user_id]
    get_member_kudos
  end

  private

    def get_member_kudos

      @kudos = @user.send("received_kudos") + @user.send("sent_kudos")
      @kudos.sort! { |a,b| b.updated_at <=> a.updated_at }
  end


end
