class AddressMatcher
  
  def name
    :address_matcher
  end
  
  def match(person: nil, potential: nil) 
    if person.address.city == potential.address.city
      match = :yes
    elsif person.address.city.nil? || potential.address.city.nil?
      match = :uncertain
    else
      match = :no
    end
    {matcher: self.name, match: match}
  end
  
end
  