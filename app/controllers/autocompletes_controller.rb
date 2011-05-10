class AutocompletesController < ApplicationController
  before_filter :authenticate_user!


  def new
    case params[:object]
      when 'identities'
        object = Identity.where("identity LIKE ?","%#{params[:term]}%").
                        order(:identity).
                        map(&:identity).
                        limit(100)
    end
    render :json => object.to_json if object.size > 0
    render :json => ['no matches'].to_json if object.size == 0
  end


end
