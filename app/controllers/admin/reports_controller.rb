class Admin::ReportsController < Admin::AdminController
  helper_method :sort_column, :sort_direction

  def index
    @reports = Report.all
  end

  def show
    @report   = Report.find params[:id]
    @objects  = @report.run!(params[:from], params[:until]) unless params[:from].blank? && params[:until].blank?
  end

  private

    def sort_column
      User.column_names.include?(params[:column]) ? (return params[:column]) : (return "email")
    end

    def sort_direction
      %{asc desc}.include?(params[:direction].to_s) ? (return params[:direction]) : (return "asc")
    end


end
