class PostalAddressMatcher
  
  def name
    :postal_address_matcher
  end
  
  def short_name
    "postal"
  end
  
  
  def match(person: nil, potential: nil)
    person_postal = postal(person)
    pot_postal = postal(potential)
    return {matcher: self.short_name, match:  :no} if person_postal.nil? || pot_postal.nil?
    match_ct = 0
    [:address_line_1, :address_line_2, :address_line_3].each do |part|
      if person_postal[part] == pot_postal[part]
        match_ct += 1
      end      
    end
    match_ct > 1 ? match = :yes : match = :no
    {matcher: self.short_name, match: match}
  end
  
  def postal(p)
    p.addresses.where(type: :postal).first
  end
  
end
  