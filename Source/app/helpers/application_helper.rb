module ApplicationHelper
  def title
    base_title = "Sallly - Sell with Sallly"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end
  
  def is_eventtype(cur, matching)
    cur == matching ? "btn btn-info" : ""
  end
end
