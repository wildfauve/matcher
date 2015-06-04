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
  
  def type_icon(type)
    case type
    when :contact
      "mail"
    when :legal_party
      "crown"
    when :client
      "torso"
    else
      ""
    end
  end
  
  def setting_types
    [Setting.types]
  end
  
  
end
