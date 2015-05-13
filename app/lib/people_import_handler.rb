class PeopleImportHandler
  
  attr_accessor :exceptions
  
  include Wisper::Publisher  
  
  def initialize(path: nil, people: nil, type: nil)
    if path
      @people = CSV.read(path)
    else
      @people = people
    end
    @type = type
    self
  end
  
  def process
    @hrd = tokenise(@people.shift)
    @people.each do |person|
      Person.load(person: add_props(person))
    end
    publish(:successful_import_event, self)
  end
  
    
  def tokenise(header)
    header.inject([]) {|out, h| out << h.downcase.gsub(" ", "_").to_sym}
  end
  
  def add_props(person)
    properties = {}
    ct = 0
    @hrd.each do |t|
      properties[t] = person[ct]
      ct += 1
    end
    properties[:type] = @type
    properties
  end
  
end