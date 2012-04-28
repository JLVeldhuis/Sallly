class PagesController < ApplicationController
  before_filter :restrict_access, :only => [:welcome, :goal, :average, :activities, :status, :get_events]

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
  
  private
  
    def restrict_access
      deny_access unless signed_in?
    end

end
