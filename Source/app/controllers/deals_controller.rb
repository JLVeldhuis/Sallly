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
    @deal.highrised = true
    begin
      if @deal.save
        redirect_to status_path, notice: 'Deal was successfully created.'
      else
        render action: "new"
      end
    rescue ActiveResource::ServerError => e
      logger.error e.message
      redirect_to status_path, notice: 'Oops there was some issue and the data did not update to the api server. Contact your administrator'
    rescue ActiveResource::ResourceNotFound => e
      logger.error e.message
      redirect_to status_path, notice: 'Oops there was some issue and the data for this deal has beed removed from the api.'
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
