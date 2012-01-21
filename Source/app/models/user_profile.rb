class UserProfile < ActiveRecord::Base
   has_many :users

   validates :cold_calls, :presence => true
   validates :visists, :presence => true
   validates :quotes, :presence => true
   validates :sales_cycle, :presence => true
   validates :estimated_time_cycle, :presence => true
end