class KudosController < ApplicationController
  layout "registered"
  before_filter :get_kudos, :only => [:new, :create]

  respond_to :html

  def new
    @kudo = Kudo.new
  end

  def create
    @kudo = current_user.sent_kudos.new params[:kudo]

    respond_with @kudo do |format|
      format.html { kudo_redirections_and_validations }
      format.js   { validate_kudo_with_javascript     }
    end
  end

  def show
    @kudos = current_user.inbox.kudos.page(params[:page]).per(5)
  end

  private

    def kudo_redirections_and_validations
        if @kudo.save
          redirect_to '/home', :notice => I18n.t(:your_kudo_has_been_sent)
        else
          render :new
        end
    end

    def validate_kudo_with_javascript
      @kudo.js_validation_only = params[:kudo][:javascript_validation_only] if params[:kudo]
      @kudo.valid?
    end

end