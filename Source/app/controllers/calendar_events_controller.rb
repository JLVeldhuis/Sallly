class CalendarEventsController < ApplicationController
    def new
        @setting = Setting.new
    end
    
    def update
        @setting = Setting.find(current_user.setting.id)
        if @setting.update_attributes(params[:setting])
            flash[:success] = "Setting updated."
            
            if params[:target].nil?
                @redirect = "settings"
            else
                @redirect = params[:target];
            end
                
            redirect_to "/#{@redirect}"
        end
    end
end
