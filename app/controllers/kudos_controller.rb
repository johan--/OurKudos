class KudosController < ApplicationController
  layout "registered"
  before_filter :get_kudos, :only => [:new, :create]
  attr_accessor :preexisting_authoriation_token

  respond_to :html

  def new
    @kudo = Kudo.new
  end

  def create
    @kudo = current_user.sent_kudos.new params[:kudo]
    if @kudo.save
      redirect_to '/home', :notice => I18n.t(:your_kudo_has_been_sent)
    else
      render :new
    end
  end

  def show
    @kudos = current_user.inbox.kudos.page(params[:page]).per(5)
  end

  private

  def set_omniauth_data
    %w(twitter facebbok).include?(params[:provider]) ?
        (provider = params[:provider]) :
        (provider = "facebook")
    self.preexisting_authorization_token = current_user.send "#{provider}_auth"
  end

end