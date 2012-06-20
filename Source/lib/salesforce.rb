OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE if Rails.env.development?
# developer says: dummy ruby script to check api calls. Will convert this to proper class and module once tried and tested

PARAMS = {"host" => "login.salesforce.com",        # Use test.salesforce.com for sandbox
"client_secret" => '4487572089048672871'   ,      # This is the Consumer Secret from Salesforce
"client_id" =>  "3MVG9Y6d_Btp4xp7N_8a3kXMmM9wsDso.QAJHDnW5EOUcu0VBumjkASNvLkL47AC.P5wHoNim1Ee6dmUX0mrz",     # This is the Consumer Key from Salesforce
"sobject_module" => "SFDC_Models",       # See below for details on using modules
"debugging" => true,                   # Can be useful while developing
"username" => "rajkrgoyal.com@gmail.com",
"password" => "helloRaj1"}

# client = Databasedotcom::Client.new(PARAMS)
# 
# # fetch client_id and client_secret
# puts client.client_id
# puts client.client_secret




