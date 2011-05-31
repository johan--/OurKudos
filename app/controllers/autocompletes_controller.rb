class AutocompletesController < ApplicationController
  before_filter :authenticate_user!

  respond_to :json

  def new
    case params[:object]
      when 'identities'
        @items = confirmed_identities(params[:term], 10).map(&:identity).uniq

      when 'recipients'

        @items = confirmed_identities(params[:q], 10).map do |identity|
          { :id => identity.id, :name => identity.identity}
        end
    end    
    render :json => ['no matches'].to_json if @items.blank?
    render :json => @items.to_json if @items.size > 0
  end


  private

    def confirmed_identities search_term, limit
      Identity.joins(:confirmation).
       where("user_id <> ?", current_user.id).
       where(:confirmations => {:confirmed => true}).
       where("identity LIKE ?","%#{search_term}%").
       order(:identity).limit(limit)
    end

end