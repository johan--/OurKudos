class KudosController < ApplicationController
  layout "registered"
  before_filter :get_kudos, :only => [:new, :create]

  respond_to :html

  def new
    @kudo = Kudo.new
  end

  def create
    @kudo = current_user.sent_kudos.new params[:kudo]
    if @kudo.save
      redirect_to root_path, :notice => I18n.t(:your_kudo_has_been_sent)
    else
      render :new
    end
  end

  def show
    @kudos = current_user.inbox.kudos.page(params[:page]).per(5)
  end

end