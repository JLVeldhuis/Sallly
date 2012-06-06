class LeadsController < ApplicationController
  
  def index
    @leads = current_user.leads
  end
  
  def refresh
    begin
      current_user.refresh_leads
    rescue SocketError => e
      logger.error e.message
      flash[:error] = "Oops! couldn't connect to the server."
    end
    redirect_to leads_path
  end
end
