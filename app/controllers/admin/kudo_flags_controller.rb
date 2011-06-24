class Admin::KudoFlagsController < Admin::AdminController

  def index
    @kudo_flag = KudoFlag.scoped.order("id DESC").
                          page(params[:page]).
                          per(25)
  end


end
