class PagesController < ApplicationController
    before_filter :restrict_access, :only => [:welcome, :goal, :average, :activities, :status]

    def status
        @event = current_user.events.new() if signed_in?
    end
    
  private
    def restrict_access
        deny_access unless signed_in?
    end

end
