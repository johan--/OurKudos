class Admin::KudoFlagsController < Admin::AdminController

  helper_method :sort_column, :sort_direction

  def index
    @kudo_flags = KudoFlag.for_management(sort_column, sort_direction).page(params[:page]).per(25)
  end


  def flag
    no_action = KudoFlagAction.process_flag_action params[:flag_action]

    selected_ids = params[:kudo_flags] 

    if selected_ids.blank? && no_action == true
       redirect_to :back, :alert => I18n.t(:select_at_least_one_kudo_flag)
    elsif selected_ids.blank? && no_action == false
      redirect_to admin_kudo_flags_path, :notice => I18n.t(:your_flag_actions_has_been_performed)
    else
      selected_ids.each do |key, value|
        flag = KudoFlag.find key.to_i
        value == 'true' ? flag.accept_flag! : flag.reject_flag!
      end
      redirect_to admin_kudo_flags_path, :notice => I18n.t(:your_flags_changes_has_been_saved)
    end
    
  end

  private

    def sort_column
        allowed_items = %w{kudo_flags.created_at kudos.body users.last_name
                           kudo_flags.flag_reason most_flagged flagged_count}
        allowed_items.include?(params[:sort]) ?
            (return params[:sort]) : (return 'kudo_flags.created_at')
    end

    def sort_direction
      %{asc desc}.include?(params[:direction].to_s) ? (return params[:direction]) : (return "asc")
    end


end
