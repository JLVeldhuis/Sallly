class SettingController < ApplicationController
  def new
    @setting = Setting.new
  end
  
  def update
    # @setting = Setting.find(current_user.setting.id)
    @setting  = current_user.setting
    if @setting.update_attributes(params[:setting])
      flash[:success] = "Setting updated."
      
      if params[:target].nil?
        @redirect = "settings"
      else
        @redirect = params[:target];
      end
          
      redirect_to status_path
    else
      render 'pages/settings'
    end
  end
end
