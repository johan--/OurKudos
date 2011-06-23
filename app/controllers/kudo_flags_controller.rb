class KudoFlagsController < ApplicationController
  before_filter :authenticate_user!, :get_kudo_copy

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
    @kudo_flag.flaggable = @kudo
    respond_with @kudo_flag
  end


  private

    def get_kudo_copy
      return false if params[:helper] != "1" && params[:helper] != "2"

      @kudo = KudoCopy.find params[:kudo_id] if params[:helper] = "1"
      @kudo = Kudo.find params[:kudo_id]     if params[:helper] = "2"
    end

end
