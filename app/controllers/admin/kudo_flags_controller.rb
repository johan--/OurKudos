class Admin::KudoFlagsController < Admin::AdminController

  helper_method :sort_column, :sort_direction

  def index
    @kudo_flags = KudoFlag.joins(:flagger).
                          joins(:kudo).
                          order("#{sort_column} #{sort_direction}").
                          page(params[:page]).per(25)
  end

  private


  private

    def sort_column
      case params[:column]
        when
        'kudo_flags.created_at',
        'kudos.body',
        'users.last_name',
        'kudo_flags.flag_reason'
        else
          'kudo_flags.created_at'
      end
    end

    def sort_direction
      %{asc desc}.include?(params[:direction].to_s) ? params[:direction] : "asc"
    end


end
