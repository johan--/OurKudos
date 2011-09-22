class AutocompletesController < ApplicationController
  before_filter :authenticate_user!

  respond_to :json

  def new
    case params[:object]
      when 'identities'
        @items = confirmed_identities(params[:term], 10).map(&:identity).uniq
      when 'recipients'
        look_for_identities_and_facebook_friends
      when 'exact'
        @items = exact_identity(params[:term])
      else
        @items  = []
    end
    render :json => ['no matches'].to_json if @items.blank?
    render :json => @items.to_json unless @items.blank?
  end

  def inline_autocomplete_identities
    @items = autocomplete_identities_for_user
    render :json => @items.to_json 
  end

  private

    def confirmed_identities search_term, limit
      Identity.confirmed_for_user(search_term, current_user).order(:identity).limit(limit)
    end

    def look_for_friends
      FacebookFriend.friends_by_name_for_user(keyword, current_user).map do |friend|
          {:id => "fb_#{friend.facebook_id}", :name => "FB - #{friend.name}"}
        end
    end

    def exact_identity search_term
      identity = exact_confirmed_identity(keyword)
      unless identity.blank?
        @exact_identity = [{ :id => identity.id, 
                            :name => (identity.is_twitter? ?
              "[#{identity.user.to_s}] @#{identity.identity}" :
              "[#{identity.user.to_s}] #{identity.identity}")}]
      else
        new_term = params[:q].gsub("@fb_","")
        friend = FacebookFriend.find_by_facebook_id(new_term)
        @exact_identity = [{:id => "fb_#{friend.facebook_id}", :name => ("FB - #{friend.name}")}] unless friend.blank?
      end
      return [] if @exact_identity.blank?
      @exact_identity
    end

    def exact_confirmed_identity keyword
      identity = Identity.find_by_identity(keyword)
      return nil if identity.nil? or identity.confirmed? == false
      identity
    end

    def look_for_identities
       identities = confirmed_identities(keyword, 10).map do |identity|
          { :id => identity.id, :name => (identity.is_twitter? ?
              "[#{identity.user.to_s}] @#{identity.identity}" :
              "[#{identity.user.to_s}] #{identity.identity}")}
       end
      return [] if identities.blank?
      identities
    end

    def look_for_identities_and_facebook_friends
      facebook_friends = look_for_friends
      identities       = look_for_identities

        @items  = facebook_friends    if identities.blank?
        @items  = identities          if facebook_friends.blank?
        @items  = facebook_friends + identities unless facebook_friends.blank? && identities.blank?
    end

    def keyword
      params[:q].gsub RegularExpressions.twitter, ''
    end

    def autocomplete_identities_for_user
      friends = current_user.friendships.map{|f| f.friend_id}
      identities = Identity.where("user_id IN (?)",friends).map do |i| 
        if i.identity_type == 'twitter'
          #If this doens't change the method can get largely refactored
          #["#{i.user.first_name} #{i.user.last_name}", "@#{i.identity}"]
          ["#{i.user.first_name} #{i.user.last_name}", "#{i.identity}"]
        elsif i.identity_type == "nonperson" && i.is_company?
          ["#{i.user.company_name}", "#{i.identity}"]
        else
          ["#{i.user.first_name} #{i.user.last_name}", "#{i.identity}"]
        end
      end
      #facebookfriends
      identities += current_user.facebook_friends.map do |friend|
        ["#{friend.name}", "fb_#{friend.facebook_id}"]
      end.uniq
    end

end
