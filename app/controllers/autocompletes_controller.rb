class AutocompletesController < ApplicationController
  before_filter :authenticate_user!

  respond_to :json

  def new
    case params[:object]
      when 'identities'
        @items = User.select('id, email').
                     where("email LIKE ?","%#{params[:term]}%").
                     order(:email).limit(100).
                     map(&:email).uniq
    end    
    render :json => ['no matches'].to_json if @items.blank?
    render :json => @items.to_json if @items.size > 0
  end


end
