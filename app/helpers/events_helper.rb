module EventsHelper
  require 'chronic'


  def render_shift(event)
    if current_user
      link_to event.summary, edit_event_path(event)
    else
      event.summary
    end
  end
  def set_up_shift_time(chronic_time)
    Chronic.parse(chronic_time).strftime('%Y-%m-%d %H:%M:%S')

  end
end
