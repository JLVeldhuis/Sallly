module ApplicationHelper
  def title
    base_title = "Sallly - Sell with Sallly"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end
  
  def logo
    image_tag("images/logo.png", :alt => "Sallly", 
                                 :class => "round logo")
  end
  
  def is_eventtype(cur, matching)
    cur == Event::EventType[matching] ? "btn btn-info" : ""
  end
end
