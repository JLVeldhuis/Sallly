class CalendarEvent < ActiveRecord::Base
  /*
   *  Raking determines youre current ranking.
   *  Keeps youre record
   */
  
  has_many :user
  validates :score, :presence => true
end