class LeadsController < ApplicationController
  def index
    @leads = current_user.leads
  end
  
  def refresh
    begin
      current_user.refresh_leads
    rescue SocketError => e
      handle_exception(e, "Couldn't connect to the server. Please try again later.")
    end
    redirect_to leads_path
  end
end
