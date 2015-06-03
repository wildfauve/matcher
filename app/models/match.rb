class Match
  
  include Mongoid::Document
  include Mongoid::Timestamps  
  
  field :score, type: Float
  #field :matched_person, type: BSON::ObjectId
  field :matched_person, type: String
  field :reducers, type: Array
  field :state, type: Symbol
  
  embedded_in :person
  
  scope :all_matches, -> {desc(:score)}
  
  def self.get_matches(filtered)
    if filtered == "true"
      self.filtered_match
    else
      self.all_matches
    end
  end
  
  def self.filtered_match
    self.gt(score: Setting.value_for('min_score')).desc(:score)
  end
  
  def self.create_me(result)
    m = self.new
    m.update_attrs(result)
    m
  end
    
  def update_attrs(result) # result is a hit as Hashie::Mash
    self.score = result._score
    self.matched_person = result._id
    self
  end
  
  def reducers 
    self.reducers = Matchers.new.process(person: self.person, potential: self.dup_person)
  end
  
  def dup_person
    Person.find(matched_person)
  end
  
  def decision(state)
    self.state = state
    self
  end
  
  def decision_made
    state == :duplicate || state == :no_duplicate
  end
  
end