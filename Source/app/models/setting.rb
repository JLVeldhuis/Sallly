class Setting < ActiveRecord::Base
  belongs_to :user
  
  WORKING_HOURS_A_DAY = 8
  CALL_GAP_IN_MINUTES = 5
  
  after_save  :populate_events
  
  # populate events like cold calls, cold visits, cold quotes
  # Calls: depends upon number of cold_calls and goal_start and goal_end
  def populate_events 
    if activity_calls > 0
      goal_period_in_mins = ((goal_end - goal_start) / 1.minute).floor
      goal_period_in_mins = (WORKING_HOURS_A_DAY.hours/1.minute).floor unless goal_period_in_mins > 0
    
      call_period         = (goal_period_in_mins / activity_calls).floor
    
      eStart = self.goal_start
      eEnd   = self.goal_start + call_period.minutes
      
      activity_calls.times do |i|
        self.user.events << Event.new({
                                        :title      => "Via setting at #{eStart} to #{eEnd}",
                                        :eventtype  => "Others",
                                        :date_from  => eStart,
                                        :date_to    => eEnd
                                     })
        eStart = eEnd + CALL_GAP_IN_MINUTES.minutes
        eEnd   += CALL_GAP_IN_MINUTES.minutes + call_period.minutes
      end
      self.user.save
    end
  end
  
  # populating methods on the basis of input values of setting
  
  # total calls 
  # calls * visits * hitrate_quotes
  def total_calls
    activity_calls * activity_visits * activity_quotes
  end
  
  # total visits 
  # visits * hitrate_quotes
  def total_visits
    activity_visits * activity_quotes
  end
  
  # total hitrate_quotes 
  # hitrate_quotes
  def total_hitrate_quotes
    activity_quotes
  end
  
  # total calls per day
  # total_calls * average_workdays_per_year
  def calls_per_day
    (total_calls.to_f / average_workdays_a_year).ceil
  end
  
  # visits per day
  # total_visits / average_workdays_per_year
  def visits_per_day
    (total_visits.to_f / average_workdays_a_year).ceil
  end
  
  # quotes per day
  # total_hitrate_quotes / average_workdays_per_year
  def quotes_per_day
    (total_hitrate_quotes.to_f / average_workdays_a_year).ceil
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
    WORKING_HOURS_A_DAY * average_workdays_a_week
  end
  
  # cold calls
  # average_working_hours_per_week / calls_per_week
  def cold_calls
    (average_working_hours_per_week.to_f/calls_per_week).ceil
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
