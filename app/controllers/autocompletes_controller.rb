class AutocompletesController < ApplicationController
  before_filter :authenticate_user!

  respond_to :json

  def new
    case params[:object]
      when 'identities'
        @items = Identity.where("identity LIKE ?","%#{params[:term]}%").
                        where("id NOT IN (?)", current_user.identities_ids).
                        order(:identity).limit(10).
                        map(&:identity).uniq
    end    
    render :json => ['no matches'].to_json if @items.blank?
    render :json => @items.to_json if @items.size > 0
  end


end