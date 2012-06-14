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
    if @event.eventtype != 1 || @event.source != true
      render 'edit.js.erb'
    else
      render 'task.js.erb'
    end
  end
  
  def accept
    @event = Event.find(params[:id])
    unless @event.update_attributes(:is_active => true)
      @error_messages = @event.errors.full_messages.join('\n')
      render "errors.js.erb"
    end
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
      if params[:source] == "plan"
        template = 'deal.js.erb'
        @deal = @event.deal ? @event.deal : @event.build_deal
      else
        template = 'update.js.erb'
      end
      respond_to do |format|
        format.html { redirect_to status_path }
        format.js   { render template }
      end
    else
      flash[:error] = "Event creation failed"
      respond_to do |format|
        format.html { render 'edit' }
        format.js   do 
          @error_messages = @event.errors.full_messages.join('\n')
          render "errors.js.erb"
        end
      end
    end
  end

  def destroy
    Event.find(params[:id]).destroy
    flash[:success] = "Event destroyed."
    redirect_to status_path
  end
end
