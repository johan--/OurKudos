class KudosController < ApplicationController

  def new
    @kudo = Kudo.new
  end

  def create
    @kudo = current_user.sent_kudos.new params[:kudo]
    if @kudo.save
      redirect_to root_path, :notice => I18n.t(:your_kudo_has_been_sent)
    else
      redirect_to home_path, :alert => I18n.t(:unable_to_send_your_kudo)
    end
  end

  def show
    @kudos = current_user.inbox.kudos.page(params[:page]).per(5)
  end

end