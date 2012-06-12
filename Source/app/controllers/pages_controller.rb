class PagesController < ApplicationController
  skip_filter :authenticate_user!, :only => [:home]

  def status
    @pending_event = current_user.events.upcoming.count > 0 ? current_user.events.upcoming.last.id : 0
  end
  
  def get_events
    @events = current_user.calendar_events_json
    render :json => @events
  end
  
  def settings
  end
end
