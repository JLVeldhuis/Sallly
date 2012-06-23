OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  
  before_filter :authenticate_user!
  
  def handle_exception(excptn, msg)
    logger.error excptn.message
    logger.error excptn.backtrace
    flash[:error] = msg
  end
end
