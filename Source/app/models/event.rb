class Event < ActiveRecord::Base
  belongs_to :user
  
  Eventtype = {
                "Cold Calls" => 1,
                "Visits"     => 2,
                "Quotes"     => 3,
                "Others"     => 4
              }
end
