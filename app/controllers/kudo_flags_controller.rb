class KudoFlagsController < ApplicationController
  before_filter :authenticate_user!, :get_kudo

  respond_to :html, :js

  def new
    @kudo_flag = current_user.kudo_flags.build
    respond_with @kudo_flag do |format|
      format.js do
        render :text => "" if @kudo.blank?
      end

    end
  end

  def create
    @kudo_flag = current_user.kudo_flags.build params[:kudo_flag]
    @kudo_flag.flagged_kudo = @kudo

    respond_with @kudo_flag do |format|
      format.js do
        unless @kudo_flag.save
          render 'errors'
        else
          @kudo_flag.process_flagging
          render 'create'
        end
      end
    end
  end


  private

    def get_kudo
      @kudo ||= Kudo.find params[:kudo_id]
    end

end
