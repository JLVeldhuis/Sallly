class Event < ActiveRecord::Base
  belongs_to :user
  belongs_to :lead
  
  has_one :deal
  
  MAX_EVENT_COUNT = 10
  
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
  
  # before_validation :check_event_limit,
  #                   :on => :create
  
  # def check_event_limit
  #   self.errors.add(:user_id, "User has reached his activity limit of #{MAX_EVENT_COUNT}") if self.user.events.count >= 10
  # end
end
