module TrackersHelper
  def set_current_time
    Time.zone = Current.user.timezone
    Time.current.strftime("%H:%M")
  end

  def set_current_date
    Time.zone = Current.user.timezone
    Date.current.strftime("%Y-%m-%d")
  end
end
