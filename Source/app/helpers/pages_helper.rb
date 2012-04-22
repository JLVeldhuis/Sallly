module PagesHelper
  def print_events
    events_js = ""
    current_user.events.each do |event|
      if event.title != nil && event.date_from != nil
        events_js += "{
                        title: '#{event.title}',
                        start: new Date(#{event.date_from.strftime('%Y, %m-1, %d, %H, %M')})"
        if event.date_to !=nil
          events_js+=",end: new Date(#{event.date_to.strftime('%Y, %m-1, %d, %H, %M')}), allDay: false"
        end
        events_js+="},"
      end
    end
    events_js = events_js.chop
    return events_js
  end
end
