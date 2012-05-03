class PagesController < ApplicationController
  skip_filter :authenticate_user!, :only => [:home]

  def status
    @event  = current_user.events.build() if signed_in?
    @month  = 02
    @year   = 2012
    @offset = Time.local(2012, 03, 01).wday
  end
  
  def get_events
    @events = current_user.calendar_events_json
    render :json => @events
  end
  
  def settings
  end
end
