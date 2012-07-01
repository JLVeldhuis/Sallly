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
    if (@event.eventtype == 1 || @event.eventtype == 2) || @event.source == true
      render 'task.js.erb'
    else
      render 'edit.js.erb'
    end
  end
  
  def accept
    @event = Event.find(params[:id])
    unless @event.update_attributes(:is_active => true)
      @error_messages = @event.errors.full_messages.join('\n')
      render "errors.js.erb"
    end
  end
  
  def trigger
    time = Time.new
    @event = Event.where("user_id = :user_id AND (date_from BETWEEN :date_start AND :date_end)", {:user_id => current_user.id,:date_start => (time - 30), :date_end => (time + 30)}).first
    
    if @event.nil?
      render 'trigger.js.erb'
    else
      render 'task.js.erb'
    end
  end
  
  def end
    @event = Event.find(params[:id])
    @deal = @event.deal ? @event.deal : @event.build_deal
  end
  
  def deal
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    @event.is_active = true
    
    template = params[:source] == "plan" ? "reload.js.erb" : "update.js.erb"
    
    if @event.update_attributes(params[:event])
      flash[:success] = "Event updated."
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
