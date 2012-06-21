class DealsController < ApplicationController
  before_filter :require_event, :only => [:create, :update]
  
  # def index
  #   @deals = Deal.all
  # end
  # 
  # def show
  #   @deal = Deal.find(params[:id])
  # end
  # 
  # def new
  #   @deal = Deal.new
  # end
  # 
  # def edit
  #   @deal = @event.deals.find(params[:id])
  # end

  def create
    @deal = @event.build_deal(params[:deal])
    @deal.highrised = true if @event.user.setting.crm_option == "highrise"
    begin
      unless @deal.save
        @error_messages = @deal.errors.full_messages.join('\n')
        render "events/errors.js.erb"
      end
    rescue ActiveResource::ServerError => e
      logger.error e.message
      @error_messages = 'Oops you have reached your limit to add deals.'
      render "events/errors.js.erb"
    rescue ActiveResource::ResourceNotFound => e
      logger.error e.message
      @error_messages = 'Oops there was some issue and the data for this deal has beed removed from the api.'
      render "events/errors.js.erb"
    end
  end

  def update
    @deal = @event.deal
    # @deal.highrised = true

    if @deal.update_attributes(params[:deal])
      redirect_to status_path, notice: 'Deal was successfully updated.'
    else
      render action: "edit"
    end
  end

  # def destroy
  #   @deal = @event.deal
  #   @deal.destroy
  # 
  #   redirect_to status_path
  # end
  
  private
  
  def require_event
    @event = current_user.events.find_by_id(params[:event_id])
    redirect_to status_path, :notice => "Event not found" unless @event
  end
end
