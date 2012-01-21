class CalendarTask < ActiveRecord::Base

 /*
  * Calendar task, self explaining....
  * Task in the Calendar
  */
 belongs_to :user
 validates :name, :presence => true
end