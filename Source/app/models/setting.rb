class Setting < ActiveRecord::Base
  belongs_to :user
  
  WORKING_MINS_A_DAY = 8.hours
  
  after_save  :populate_events
  
  # populate events like cold calls, cold visits, cold quotes
  # Calls: depends upon number of cold_calls and goal_start and goal_end
  def populate_events
    counter = 0 
    timePeriods = []
    total_activities = 30
    gStart  = goal_start.to_time + 9.hours # day starts from 9 in the morning
    gEnd    = goal_end.to_time + 17.hours  # day ends at 5 in the evening
    
    if total_activities > 0
      goal_period_in_days = ((gEnd - gStart) / 1.day).ceil
      calls_per_day       = (total_activities / goal_period_in_days).ceil
      
      call_period         = (WORKING_MINS_A_DAY / calls_per_day).floor
      eStart              = 0
      eEnd                = 0
      goal_period_in_days.times do |gp|
        eStart  = gStart + gp.day
        calls_per_day.times do |calll|
          eEnd        = eStart + call_period
          timePeriods << [eStart, eEnd]
          eStart      = eEnd
        end
      end
      
      activity_calls.times do
        self.user.events << Event.new({
                                        :title      => "Call: Via setting",
                                        :eventtype  => "Others",
                                        :date_from  => timePeriods[counter][0],
                                        :date_to    => timePeriods[counter][1]
                                     })
        counter +=1
      end
      
      activity_visits.times do |i|
        self.user.events << Event.new({
                                        :title      => "Visit: Via setting",
                                        :eventtype  => "Visits",
                                        :date_from  => timePeriods[counter][0],
                                        :date_to    => timePeriods[counter][1]
                                     })
        counter +=1
      end
      
      activity_quotes.times do |i|
        self.user.events << Event.new({
                                        :title      => "Quote: Via setting",
                                        :eventtype  => "Quotes",
                                        :date_from  => timePeriods[counter][0],
                                        :date_to    => timePeriods[counter][1]
                                     })
        counter +=1
      end

    end
    
    self.user.save
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
