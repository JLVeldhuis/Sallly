class LeadsController < ApplicationController
  
  def index
    @leads = current_user.leads
  end
  
  def refresh
    current_user.refresh_leads
    redirect_to leads_path
  end
end
