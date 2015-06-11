class EmailFilter
  
  def run
    source = Person.gt('matches.score' => Setting.value_for('min_score'))
    source.inject([]) do |target, person|
      fn = person.matches.and('reducers.email' => true)
      if fn.count > 0
        target << person
      end
      target
    end
    
  end
  
  def fired?(match)
    match.reducers["email"] 
  end
  
  def name
    "All + Email Filter"
  end
  
  def desc
    "All matches where the phonetic score is greater than #{Setting.value_for('min_score')} and the email addresses is an exact match"
  end
end