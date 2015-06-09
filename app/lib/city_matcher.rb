class CityMatcher
  
  def name
    :city_matcher
  end
  
  def short_name
    "city"
  end
  
  
  def match(person: nil, potential: nil) 
    person_cities = cities(person)
    pot_cities = cities(potential)
    if person_cities == pot_cities
      match = true
    else
      match = false
    end
    {matcher: self.short_name, match: match}
  end
  
  def cities(p)
    p.addresses.collect(&:city).uniq!
  end
  
end
  