module Exceptions
  class SalesforceAuthenticationFailure < StandardError
    def message
      "Sorry unable to authenticate the salesforce client! Contact your administrator or try again later."
    end
  end
end
