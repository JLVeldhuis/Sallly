class CalendarEvent < ActiveRecord::Base

 /*
  * Calendar evet, self explaining....
  * event in the Calendar
  */
 belongs_to :user
 validates :name, :presence => true
 validates :type, :presence => true
end