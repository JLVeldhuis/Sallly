class SfleadsController < ApplicationController
   include Databasedotcom::Rails::Controller
   
   def index
     config = YAML.load_file(File.join(::Rails.root, 'config', 'databasedotcom.yml'))
     client = Databasedotcom::Client.new(config)
     client.authenticate :username => config[:username], :password => config[:password]
     @users = client.query("select id, name from account where name like 'United%'")
   end
end
