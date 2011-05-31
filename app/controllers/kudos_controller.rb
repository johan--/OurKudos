class KudosController < ApplicationController

  def create
    @kudo = Kudo.new params[:kudo]
    if @kudo.save
      redirect_to root_path, :notice => I18n.t(:your_kudo_has_been_sent)
    else
      redirect_to home_path, :alert => I18n.t(:unable_to_send_your_kudo)
    end
  end

  def show
    current_user.inbox.find_by_name()
  end

end