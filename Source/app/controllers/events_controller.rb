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
  
  def edit
    @event = Event.find(params[:id])
    if @event.eventtype != 1
      render 'edit.js.erb'
    else
      render 'task.js.erb'
    end
  end
  
  def accept
    @event = Event.find(params[:id])
    render :nothing => true unless @event.update_attributes(:is_active => true)
  end
  
  def end
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    @event.is_active = true
    if @event.update_attributes(params[:event])
      message = {:channel => task_path, :data => { :event_id => @event.id, :event_title => @event.title}}
      # uri = URI.parse("http://localhost:9292/faye")
      # Net::HTTP.post_form(uri, :message => message.to_json)
      flash[:success] = "Event updated."
    else
      flash[:error] = "Event creation failed"
    end
    redirect_to status_path
  end

  def destroy
    Event.find(params[:id]).destroy
    flash[:success] = "Event destroyed."
    redirect_to status_path
  end
end
