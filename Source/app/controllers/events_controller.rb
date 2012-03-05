class EventsController < ApplicationController
    def create
        @event = Event.new(params[:event])
        if @event.save
            flash[:success] = "Event created"
            else
            flash[:error] = "Event creation failed"
        end
        redirect_to status_path
    end
    
    def new
        @event = Event.new if signed_in?
    end
    
    def update
        @event = Event.find(params[:id])
        if @event.update_attributes(params[:event])
            flash[:success] = "Event updated."
            else
            flas[:error]    = "Event creation failed"
        end
        redirect_to status_path
    end
    
    def destroy
        Event.find(params[:id]).destroy
        flash[:success] = "Event destroyed."
        redirect_to status_path
    end

end
