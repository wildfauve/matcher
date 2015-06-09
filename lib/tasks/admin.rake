namespace :admin do
  
  desc "Load contact people from csv"
  task load_contact: :environment do
    people = CSV.read('/Volumes/Person_Data/1_contact_person.csv', {:col_sep => "|"})
    handler = PeopleImportHandler.new(people: people, type: :contact)
    handler.process
  end

  desc "Load Legal Parties from csv"
  task load_legal: :environment do
    people = CSV.read('/Volumes/Person_Data/1_legal_parties.csv', {:col_sep => "|"})
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
    people = CSV.read('/Volumes/Person_Data/1_client_individual.csv', {:col_sep => "|"})
    handler = PeopleImportHandler.new(people: people, type: :client)
    handler.process
  end

  desc "Match People"
  task match: :environment do
    Person.comparison
  end
  
  desc "Output All Filtered"
  task output_filtered: :environment do
    OutputGenerator.new(filter: AllFilter.new, file: "/Users/colperks/Documents/Customers--Local Only/Fishserve/personal data/all_filtered.json").generate
  end

  desc "Output Filtered Fullname"
  task output_fullname: :environment do
    OutputGenerator.new(filter: FullNameFilter.new, file: "/Users/colperks/Documents/Customers--Local Only/Fishserve/personal data/full_name_filtered.json").generate
  end

  desc "Output Filtered Email Fullname"
  task output_email_fullname: :environment do
    OutputGenerator.new(filter: EmailFullNameFilter.new, file: "/Users/colperks/Documents/Customers--Local Only/Fishserve/personal data/email_full_name_filtered.json").generate
  end

end
