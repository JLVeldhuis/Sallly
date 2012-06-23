require 'exceptions'
module SSalesforce
  class SSalesforce
    include Exceptions
    
    attr_accessor :auth, :config, :client
  
    def initialize(args)
      self.auth   = args[:auth]
      self.config = YAML.load_file(File.join(::Rails.root, 'config', 'databasedotcom.yml'))
      self.client ||= Databasedotcom::Client.new(config)
      
      authenticate
    end
  
    def authenticate
      raise SalesforceAuthenticationFailure unless client.authenticate auth
    end
  
    def leads
      lead_class = client.materialize("Lead")
      SFDC_Models::Lead.all
    end
  end
end