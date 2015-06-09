class AllFilter
  
  def run
    Person.gt('matches.score' => Setting.value_for('min_score')).order_by(hits: :desc, full_name: :asc)
  end
  
  def name
    "All Filter"
  end
  
  def fired?(person)
    true
  end
  
  def desc
    "All matches where the phonetic score is greater than #{Setting.value_for('min_score')}"
  end
end