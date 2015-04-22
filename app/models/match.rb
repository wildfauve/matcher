class Match
  
  include Mongoid::Document
  include Mongoid::Timestamps  
  
  field :score, type: Float
  #field :matched_person, type: BSON::ObjectId
  field :matched_person, type: String
  
  embedded_in :person
  
  def self.create_me(result)
    m = self.new
    m.update_attrs(result)
    m
  end
    
  def update_attrs(result)
    self.score = result._score
    self.matched_person = result._id
    self
  end
  
  def dup_person
    Person.find(matched_person)
  end
  
end