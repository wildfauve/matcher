namespace :admin do
  
  desc "Load people from csv"
  task load: :environment do
    people = CSV.read('lib/load_files/contact_person_test_2.csv', {:col_sep => "|"})
    handler = PeopleImportHandler.new(people: people, type: :contact)
    handler.process
  end

  desc "Load Legal Parties from csv"
  task load_legal: :environment do
    people = CSV.read('/Users/wildfauve/Documents/customers/FishServe/data/legal_parties.csv', {:col_sep => "|"})
    handler = PeopleImportHandler.new(people: people, type: :legal_party)
    handler.process
  end


  desc "Match People"
  task match: :environment do
    Person.comparison
  end

end
