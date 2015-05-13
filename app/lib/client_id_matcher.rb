class ClientIdMatcher
  
  def name
    :client_id_matcher
  end
  
  def short_name
    "client id"
  end
  
  def match(person: nil, potential: nil) 
    if person.client_id == potential.client_id
      match = :yes
    elsif person.client_id.nil? || potential.client_id.nil?
      match = :uncertain
    else
      match = :no
    end
    {matcher: self.short_name, match: match}
  end
  
end