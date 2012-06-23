class RegistrationsController < ApplicationController
  skip_filter :authenticate_user!
  
  def email
    if request.post?
      if session[:omniauth]
        if params[:email]
          @user = User.find_for_service_oauth_with_email(params[:email], session[:omniauth], current_user)
          if @user and @user.persisted?
            flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => session[:omniauth][:provider]
            sign_in_and_redirect @user, :event => :authentication
          else
            flash[:notice] = "Authentication failed, as this account is already linked to another email address" if @user.errors and !@user.errors[:authentications].blank?
            session["devise.#{session[:omniauth][:provider]}_data"] = request.env["omniauth.auth"]
            redirect_to new_user_registration_url
          end
        end
      else
        flash[:notice] = "Sorry! your authentication process failed"
        redirect_to new_user_registration_url
      end
    end
  end
end
