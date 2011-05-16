class GatewayController < ApplicationController




  def show
    redirect_to :back if params[:what].blank?
      case params[:what]
        when "merge"
          redirect_to new_merge_path
      end
  end


  private



end
