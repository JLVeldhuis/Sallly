module TwilioClientHelper
  def account_sid
    'ACa0c58edff2ab4da9bd1956d388851fb5'
  end
  
  def auth_token
    'dac8eaeaa7b20f331267a15dac1ffd96'
  end
  
  def twilio_token
    capability = Twilio::Util::Capability.new account_sid, auth_token
    capability.allow_client_outgoing "APcaf786afdb174a289f0fad7cd15329ab"
    capability.generate
  end
end
