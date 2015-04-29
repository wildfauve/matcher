module ApplicationHelper
  
  def active_test(match)
    case match
      when :yes 
        "active"
      when :no
        "inactive"
      when :uncertain
        "uncertain"
      else
        ""
    end
  end
  
end
