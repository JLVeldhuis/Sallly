class PagesController < ApplicationController
    before_filter :restrict_access, :only => [:welcome, :goal, :average, :activities, :status]

    def status
        @event = current_user.events.new() if signed_in?
        @month = 02
        @year  = 2012
        @offset = Time.local(2012, 03, 01).wday
    end
    
  private
    def restrict_access
        deny_access unless signed_in?
    end

end
