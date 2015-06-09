class EmailFullNameFilter
  
  def run
    source = Person.gt('matches.score' => Setting.value_for('min_score'))
    source.inject([]) do |target, person|
      fn = person.matches.and('reducers.fullname' => true, 'reducers.email' => true)
      if fn.count > 0
        target << person
      end
      target
    end
    
  end
  
  def fired?(match)
    match.reducers["fullname"] && match.reducers["email"] 
  end
  
  def name
    "All + Full Name + Email Filter"
  end
  
  def desc
    "All matches where the phonetic score is greater than #{Setting.value_for('min_score')} and the Fullname and email addresses are an exact match"
  end
end