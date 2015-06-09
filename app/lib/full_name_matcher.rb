class FullNameMatcher
  
  def name
    :full_name_matcher
  end
  
  def short_name
    "fullname"
  end
  
  
  def match(person: nil, potential: nil) 
    if person.full_name.nil? || potential.full_name.nil?
      match = false
    elsif person.full_name == potential.full_name
      match = true
    else
      match = false
    end
    {matcher: self.short_name, match: match}
  end
  
  
end
  