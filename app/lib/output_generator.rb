class OutputGenerator
  
  def initialize(filter: nil, file: nil)
    @filter = filter
    @file = file
  end
  
  def generate
    File.open(@file, 'w') { |file| file.write(Person.generate_download(@filter.run, @filter)) }
  end
  
end