class EmailMatcher
  
  def name
    :email_matcher
  end
  
  def short_name
    "email"
  end
  
  
  def match(person: nil, potential: nil) 
    if person.email.nil? || potential.email.nil?
      match = false
    elsif person.email == potential.email
      match = true
    else
      match = false
    end
    {matcher: self.short_name, match: match}
  end
  
  
end
  