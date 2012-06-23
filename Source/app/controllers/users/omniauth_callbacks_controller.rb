class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_filter :authenticate_user!, :only => :salesforce
  
  def facebook
    # You need to implement the method below in your model
    @user = User.find_for_service_oauth(request.env["omniauth.auth"], current_user)

    if @user and @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
  
  def linkedin
    #save twitter callback information in session as session[:omniauth] for later use
    omniauth = request.env["omniauth.auth"]
    session["omniauth"] = {
                            :uid => omniauth.uid,
                            :provider => omniauth.provider,
                            :credentials => omniauth.credentials,
                            :extra => {:raw_info => {:name => omniauth.name, :username => omniauth.screen_name}}
                         }
    # get the email address from user as input
    redirect_to email_path
  end
  
  def twitter
    #save twitter callback information in session as session[:omniauth] for later use
    omniauth = request.env["omniauth.auth"]
    session["omniauth"] = {
                            :uid => omniauth.uid,
                            :provider => omniauth.provider,
                            :credentials => omniauth.credentials,
                            :extra => {:raw_info => {:name => omniauth.name, :username => omniauth.screen_name}}
                         }
    # get the email address from user as input
    redirect_to email_path
  end
  
  def google_apps
    @user = User.find_for_service_oauth(request.env["omniauth.auth"], current_user)

    if @user and @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.google_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
  
  def salesforce
    @user = User.find_for_service_oauth(request.env["omniauth.auth"], current_user)
    if @user and @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "SalesForce"
      begin
        current_user.refresh_leads_via_salesforce(request.env["omniauth.auth"])
      rescue Exceptions::SalesforceAuthenticationFailure => e
        handle_exception(e, e.message)
      end
      redirect_to leads_url
    else
      session["devise.salesforce_data"] = request.env["omniauth.auth"]
      redirect_to setting_path
    end
  end
  
  def passthru
    render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    # Or alternatively,
    # raise ActionController::RoutingError.new('Not Found')
  end
end