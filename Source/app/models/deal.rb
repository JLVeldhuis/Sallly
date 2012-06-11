class Deal < ActiveRecord::Base
  belongs_to :event
  
  DEALTYPE = {
               "Fixed bid"    => "fixed",
               "Per hour"     => "hour",
               "Per month"    => "month",
               "Per year"     => "year"
             }
             
  CURRENCY = {
                "$ - USD"   => "USD",
                "# - POUND" => "POUND"
             }
             
  CATEGORY = {
                "None" => "NONE"
             }
end
