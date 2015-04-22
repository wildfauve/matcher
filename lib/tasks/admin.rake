namespace :admin do
  
  desc "Load peope from csv"
  task load: :environment do
    Person.destroy_all
    people = CSV.read('lib/load_files/contact_person_test.csv', {:col_sep => "|"})
    handler = PeopleImportHandler.new(people: people)
    handler.process
  end

  desc "Match People"
  task match: :environment do
    Person.comparison
  end


    
end
