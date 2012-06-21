class SfleadsController < ApplicationController
   include Databasedotcom::Rails::Controller
   
   def index
     config = YAML.load_file(File.join(::Rails.root, 'config', 'databasedotcom.yml'))
     client = Databasedotcom::Client.new(config)
     client.authenticate request.env["omniauth.auth"]
     @users = client.query("select id, name from leads")
   end
end
