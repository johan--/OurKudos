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
        @items = exact_identity(params[:q])
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
      unless search_term.blank?
        Identity.confirmed_for_user(search_term, current_user)
      else
        []
      end
    end

    def twitter_identities search_term, limit
      Identity.twitter_for_user(search_term, current_user)
    end

    def virtual_identities search_term, limit
      Identity.virtual_for_user(search_term, current_user)
    end

    def combined_identities search_term, limit
      identities = confirmed_identities(search_term, limit) + virtual_identities(search_term, limit) + twitter_identities(search_term, limit)
      identities.uniq.first(10).sort_by(&:identity)
    end

    def look_for_friends
      unless params[:q].blank?
        FacebookFriend.friends_by_name_for_user(params[:q], current_user).map do |friend|
            {:id => "fb_#{friend.facebook_id}", :name => "#{friend.name} (Facebook)"}
        end 
       else
         []
       end
    end

    def exact_identity search_term
      identity = exact_confirmed_identity(search_term)
      unless identity.blank?
        @exact_identity = identity.autocomplete_name
      else
        new_term = params[:q].gsub("@fb_","")
        friend = FacebookFriend.find_by_facebook_id(new_term)
        @exact_identity = [{:id => "fb_#{friend.facebook_id}", :name => ("FB - #{friend.name}")}] unless friend.blank?
      end
      return [] if @exact_identity.blank?
      @exact_identity
    end

    def exact_confirmed_identity search_term 
      search_for = search_term.gsub RegularExpressions.twitter, ''
      identity = Identity.find_by_identity(search_for) 
      return nil if identity.blank?
      if identity.identifiable_type == 'VirtualUser'
        return identity
      else
        #return nil if identity.confirmed? == false
        return identity
      end
      return identity
    end

    def look_for_identities
       identities = combined_identities(keyword, 10).map do |identity|
          { :id => identity.id, :name => (identity.is_twitter? ?
              "#{identity.identifiable.to_s} (Twitter: @#{identity.identity})" :
              "#{identity.identifiable.to_s} (Email)")}
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
      friends = current_user.friendships.map{|f| f.friendable}
      friends_identities = friends.map{|f| f.identities}.flatten
      identities = []
      friends_identities.each do |i|
        if i.identifiable_type == 'VirtualUser' && i.identity_type == 'twitter'
          identities << ["#{i.identifiable.to_s}", "@#{i.identity}"]
        elsif i.identifiable_type == 'VirtualUser' && i.identity_type == 'email'
          identities << ["#{i.identifiable.to_s}", "#{i.identity}"]
        elsif i.identity_type == 'twitter'
          identities << ["#{i.user.first_name} #{i.user.last_name}", "@#{i.identity}"]
        elsif i.identity_type == "nonperson" && i.is_company?
          identities << ["#{i.user.company_name}", "#{i.identity}"]
        else
          identities << ["#{i.user.first_name} #{i.user.last_name}", "#{i.identity}"]
        end
      end
      identities += current_user.facebook_friends.map do |friend|
        ["#{friend.name}", "fb_#{friend.facebook_id}"]
      end.uniq
    end

end
