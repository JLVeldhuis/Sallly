class PagesController < ApplicationController
  skip_filter :authenticate_user!, :only => [:home]

  def status
  end
  
  def get_events
    @events = current_user.calendar_events_json
    render :json => @events
  end
  
  def settings
  end
end
