class Event < ActiveRecord::Base
  belongs_to :user
  belongs_to :lead
  
  Eventtype = {
                "Cold Calls" => 1,
                "Visits"     => 2,
                "Quotes"     => 3,
                "Others"     => 4
              }
              
  # all inactive events 
  scope :inactive, where(:is_active => false)
  
  # all inactive events from taskmanager 
  scope :via_taskmanager_and_inactive, where(:source => true, :is_active => false)
end
