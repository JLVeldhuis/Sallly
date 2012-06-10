module EventsHelper
  
  def get_title(eventtype, source)
    source ? "Did you made planned a meeting visit?" : "Incoming #{User.get_event_class_name(eventtype)}"
  end
end
