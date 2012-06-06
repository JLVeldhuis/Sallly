class Setting < ActiveRecord::Base
  belongs_to :user
  
  WORKING_MINS_A_DAY = 8.hours
  
  after_update  :populate_events_if_required
  
  
  # Validations
  
  validates :activity_calls,
            :activity_visits,
            :activity_quotes,
            :presence => true,
            :on       => :update
  
  # populate events like cold calls, cold visits, cold quotes
  # Calls: depends upon number of cold_calls and goal_start and goal_end
  def populate_events_if_required
    @lcounter = 0
    @userLeads = self.user.leads
    if relevant_fields_changed
      # remove redundant events from the system for the setting
      flush_redundant_events
      total_activities_per_day = cold_calls_per_day

      # we need to figure out a way to track the time zone as per the ip address
      gStart  = Time.zone.local(goal_start.year, goal_start.month, goal_start.day, 9, 0, 0)
      gEnd    = Time.zone.local(goal_end.year, goal_end.month, goal_end.day, 17, 0, 0)
    
      if total_activities_per_day > 0
        # goal_period_in_days = ((gEnd - gStart) / 1.day).ceil
        activities_per_day      = total_activities_per_day
        activity_period_in_mins = ((WORKING_MINS_A_DAY/activities_per_day)/60).floor
        eStart                  = 0
        eEnd                    = 0
        gStart.to_date.upto(gEnd.to_date) do |gp|
          unless [0,6].include?(gp.wday) #is_working_day
            counter = 0 
            timePeriods = []
            eStart  = Time.zone.local(gp.year, gp.month, gp.day, 9, 0, 0) #gStart + gp.day
            activities_per_day.times do |activity|
              eEnd        = activity_period_in_mins.minutes.since(eStart)
              timePeriods << [eStart, eEnd]
              eStart      = eEnd
            end
            total_activities_per_day.times do
              next_lead = get_next_lead
              if next_lead 
                next_lead_id = next_lead.id
                title = "Call: Via setting with #{next_lead.name}" 
              else
                title = "Call: Via setting"
                next_lead_id = nil
              end
              self.user.events << Event.new({
                                              :title      => title,
                                              :eventtype  => 1,
                                              :date_from  => timePeriods[counter][0],
                                              :date_to    => timePeriods[counter][1],
                                              :source     => true,
                                              :lead_id    => next_lead_id
                                           })
              counter +=1
              @lcounter +=1
            end
          end
        end

      end
    
      self.user.save
    end
  end
  
  def get_next_lead
    if @userLeads.count > 0
      @lcounter = 0 if @lcounter >= @userLeads.count
      @userLeads[@lcounter]
    end
  end
  
  # remove redundant events from the system for the setting
  def flush_redundant_events
    self.user.events.via_taskmanager_and_inactive.delete_all
  end
  
  def relevant_fields_changed
    ["goal_start", "goal_end", "goal_revenue", "average_revenue", "activity_calls", "activity_visits", "activity_quotes", "average_workdays_a_year", "average_workdays_a_week"].each do |atttr|
     return true if self.send(atttr + "_changed?")
    end
    false
  end
  
  # hitrate is Goal/ Average amount
  def hitrate
    goal_revenue.to_f/average_revenue.to_f
  end
  
  def total_calls
    hitrate * activity_calls * activity_visits * activity_quotes
  end
  
  # populating methods on the basis of input values of setting
  
  # total calls 
  # calls * visits * hitrate_quotes
  # def total_calls
  #   (activity_calls * activity_visits * activity_quotes).to_f
  # end
  
  # total visits 
  # visits * hitrate_quotes
  def total_visits
    (activity_visits * activity_quotes).to_f
  end
  
  # total hitrate_quotes 
  # hitrate_quotes
  def total_hitrate_quotes
    (activity_quotes).to_f
  end
  
  # total calls per day
  # total_calls * average_workdays_per_year
  def calls_per_day
    (total_calls / average_workdays_a_year).ceil
  end
  
  # visits per day
  # total_visits / average_workdays_per_year
  def visits_per_day
    (total_visits / average_workdays_a_year).ceil
  end
  
  # quotes per day
  # total_hitrate_quotes / average_workdays_per_year
  def quotes_per_day
    (total_hitrate_quotes / average_workdays_a_year).ceil
  end
  
  # calls per week
  # calls per day * average_workdays_per_week
  def calls_per_week
    calls_per_day * average_workdays_a_week
  end
  
  # visits per week
  # visits per day * average_workdays_per_week
  def visits_per_week
    visits_per_day * average_workdays_a_week
  end
  
  # quotes per week
  # quotes per day * average_workdays_per_week
  def quotes_per_week
    quotes_per_day * average_workdays_a_week
  end
  
  # average_working_hours_per_week
  # WORKING_HOURS_A_DAY * average_workdays_per_week
  def average_working_hours_per_week
    8 * average_workdays_a_week
  end
  
  # cold calls
  # average_working_hours_per_week / calls_per_week
  def cold_calls
    (average_working_hours_per_week.to_f/calls_per_week).ceil
  end
  
  def cold_calls_per_day
    (cold_calls.to_f/average_workdays_a_week.to_f).ceil
  end
  
  # cold visits
  # average_working_hours_per_week / visits_per_week
  def cold_visits
    (average_working_hours_per_week.to_f/visits_per_week).ceil
  end
  
  # cold quotes
  # average_working_hours_per_week / quotes_per_week
  def cold_quotes
    (average_working_hours_per_week.to_f/quotes_per_week).ceil
  end
  
  # value per call
  # revenue goal / total_calls
  def value_per_call
    goal_revenue/total_calls
  end
  
  # value per visit
  # revenue goal / total_visits
  def value_per_visit
    goal_revenue/total_visits
  end
  
  # value per quote
  # revenue goal / total_hitrate_quotes
  def value_per_quote
    goal_revenue/total_hitrate_quotes
  end
end
