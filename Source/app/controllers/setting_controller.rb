class SettingController < ApplicationController
  def new
    @setting = Setting.new
  end
  
  def update
    @setting  = current_user.setting
    if @setting.update_attributes(params[:setting])
      flash[:success] = "Setting updated."
      redirect_to status_path
    else
      flash[:success] = "Setting update failes."
      redirect_to setting_path
    end
  end
end
