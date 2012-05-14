class SessionsController < Devise::SessionsController

  def destroy
    session["omniauth"] = nil
    super
  end

end
