class AddressMatcher
  
  def name
    :address_matcher
  end
  
  def short_name
    "address"
  end
  
  
  def match(person: nil, potential: nil) 
    person_cities = cities(person)
    pot_cities = cities(potential)
    if person_cities == pot_cities
      match = :yes
    elsif person_cities.nil? || pot_cities.nil?
      match = :uncertain
    else
      match = :no
    end
    {matcher: self.short_name, match: match}
  end
  
  def cities(p)
    p.addresses.collect(&:city).uniq!
  end
  
end
  