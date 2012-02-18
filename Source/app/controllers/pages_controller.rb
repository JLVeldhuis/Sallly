class PagesController < ApplicationController
  before_filter :restrict_access, :only => [:welcome, :goal, :average, :activities]

    @text = "hello"
    
  private
    def restrict_access
        deny_access unless signed_in?
    end

end
