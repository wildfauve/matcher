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


  desc "Load Signing Auth from csv"
  task load_signing: :environment do
    people = CSV.read('/Users/wildfauve/Documents/customers/FishServe/data/1_signing_auth.csv', {:col_sep => "|"})
    handler = PeopleImportHandler.new(people: people, type: :signing_auth)
    handler.process
  end

  desc "Load Client Individuals from csv"
  task load_client: :environment do
    people = CSV.read('/Users/wildfauve/Documents/customers/FishServe/data/1_client_individual.csv', {:col_sep => "|"})
    handler = PeopleImportHandler.new(people: people, type: :client)
    handler.process
  end



  desc "Match People"
  task match: :environment do
    Person.comparison
  end

end
