class FriendshipsController < ApplicationController
  before_filter :authenticate_user!
  layout "registered"

  def create
    @friendship = current_user.friendships.build :friend_id => params[:friend_id]
    if @friendship.save
      redirect_to home_path, :notice => I18n.t(:added_friend)
    else
      redirect_to home_path, :notice => I18n.t(:not_added_friend)
    end
  end

  def show
  end

end
