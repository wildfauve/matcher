class EmailMatcher
  
  def name
    :email_matcher
  end
  
  def short_name
    "email"
  end
  
  
  def match(person: nil, potential: nil) 
    if person.email == potential.email
      match = :yes
    elsif person.email.nil? || potential.email.nil?
      match = :uncertain
    else
      match = :no
    end
    {matcher: self.short_name, match: match}
  end
  
  
end
  