class AutocompletesController < ApplicationController
  before_filter :authenticate_user!

  respond_to :json

  def new
    case params[:object]
      when 'identities'
        @items = confirmed_identities(params[:term], 10).map(&:identity).uniq

      when 'recipients'
        facebook_friends = look_for_friends
        identities       = look_for_identities
        @items  = facebook_friends    if identities.blank?
        @items  = identities          if facebook_friends.blank?
        @items = facebook_friends + identities unless facebook_friends.blank? && identities.blank?
    end
    render :json => ['no matches'].to_json if @items.blank?
    render :json => @items.to_json unless @items.blank?
  end


  private

    def confirmed_identities search_term, limit
      Identity.joins(:confirmation).
       where("user_id <> ?", current_user.id).
       where(:confirmations => {:confirmed => true}).
       where("identity LIKE ?","%#{search_term}%").
       order(:identity).limit(limit)
    end

    def look_for_friends
      ffriends = current_user.facebook_friends
      return ffriends if ffriends.blank?

      ffriends.where("lower(first_name) LIKE lower(?) OR lower(last_name) LIKE lower(?)","#{params[:q]}%", "#{params[:q]}%").map do |friend|
          {:id => "fb_#{friend.identifier}", :name => "FB - #{friend.name}"}
        end if !ffriends.blank?
    end

    def look_for_identities
       identities = confirmed_identities(params[:q], 10).map do |identity|
          { :id => identity.id, :name => (identity.is_twitter? ? "@#{identity.identity}" : identity.identity)}
       end
      return [] if identities.blank?
      identities
    end

end