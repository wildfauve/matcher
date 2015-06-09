class FullNameFilter
  
  def run
    source = Person.gt('matches.score' => Setting.value_for('min_score'))
    source.inject([]) do |target, person|
      fn = person.matches.where('reducers.fullname' => true)
      if fn.count > 0
        target << person
      end
      target
    end
    
  end
  
  def fired?(match)
    match.reducers["fullname"]
  end
  
  def name
    "All + Full Name"
  end
  
  def desc
    "All matches where the phonetic score is greater than #{Setting.value_for('min_score')} and the Fullname is an exact match"
  end
end