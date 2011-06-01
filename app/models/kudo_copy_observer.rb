class KudoCopyObserver < ActiveRecord::Observer

  def after_create record
    UserNotifier.kudo(record.kudoable).deliver! if record.kudoable.is_a?(EmailKudo)
  end

end
