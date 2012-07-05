OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  
  before_filter :authenticate_user!

  def after_sign_in_path_for(resource)
    if current_user.first_login?
      current_user.update_attribute :first_login, 0
      return settings_path
    else
      return status_path
    end
  end
  
  def handle_exception(excptn, msg)
    logger.error excptn.message
    logger.error excptn.backtrace
    flash[:error] = msg
  end
end
