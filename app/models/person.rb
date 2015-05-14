class Person
  
  include Wisper::Publisher

  include Mongoid::Document
  include Mongoid::Timestamps  
  #include Hashie::Extensions::Mash
  include Mongoid::Elasticsearch
  
  elasticsearch!({
    # index name (prefix is added)
    index_name: "people-#{Rails.env}",

    # don't use global name prefix
    prefix_name: false,

    index_options: {
        # elasticsearch index definition
      settings: {
        index: {
          analysis: {
            filter: {
              dbl_metaphone: {
                type: "phonetic",
                  encoder: "double_metaphone"
                }
              },
              analyzer: {
                dbl_metaphone: {
                  replace: "true",
                  filter: ["standard", "lowercase", "dbl_metaphone"],
                  tokenizer: "standard"
                },
                email: {
                  tokenizer: "uax_url_email"
                }
              }
            }
          }
        },
        mappings: {
          "person" => {
            properties: {
              email: {
                type: "string",
                analyzer: "email"
              },
              full_name: {
                type: "string",
                analyzer: "dbl_metaphone"
              }
            }
          }
        }
      },  
    wrapper: :load
  })
    
  field :type, type: Symbol # contact_person
  field :contact_id, type: String # contact_person
  field :client_id, type: String # contact_person
  field :full_name, type: String # agg first_name, surnam
  field :relationship, type: String # contact_person
  field :department, type: String # contact_person
  field :phone_area, type: String # contact_person
  field :phone, type: String # contact_person
  field :phone_country, type: String # contact_person
  field :fax_area, type: String # contact_person
  field :fax_no, type: String # contact_person
  field :fax_country, type: String # contact_person
  field :email, type: String # contact_person
  field :hits, type: Integer
  
  embeds_many :addresses
  
  embeds_many :matches
    
  

=begin
-- Client_ID, Client_Type, Legal_Name, Title, First_Names, Surname, Preferred_Name, DoB
select Client_ID, Client_Type, Legal_Name, isnull(Title, '') [Title], First_Names, Surname, isnull(Preferred_Name, '') [Preferred_Name]
, isnull(convert(varchar(10), Commencement_Date, 120), '') as DOB
from Client where Client_Type = 'individual'

-- Client_ID, Legal_Party_ID, First_Name, Surname, Preferred_Name, Title, DOB, Gender, Deceased_Date
select Client_ID, Legal_Party_ID, First_Name, Surname
, isnull(Preferred_Name, '') [Preferred_Name]
, isnull(Title, '') [Title]
, isnull(convert(varchar(10), DOB, 120), '') as DOB
, isnull(Gender, '') [Gender]
, isnull(convert(varchar( 10), Deceased_Date, 120), '') [Deceased_Date]
from Legal_Parties

-- Contact_ID, Client_ID, First_Name, Surname, Relationship, Address_Line_1, Address_Line_2, Address_Line_3, City, Country, Post_Code, Department, Phone_Area, Phone, Phone_Country, Fax_Area,Fax_No, Fax_Country,Email 
select Contact_ID, Client_ID, First_Name, Surname, Relationship
, isnull(Address_Line_1, '') [Address_Line_1]
, isnull(Address_Line_2, '') [Address_Line_2]
, isnull(Address_Line_3, '') [Address_Line_3]
, isnull(City, '') [City]
, isnull(Post_Code, '') [Post_Code]
, isnull(Department, '') [Department]
, isnull(Phone_Country, '') [Phone_Country], isnull(Phone_Area, '') [Phone_Area], isnull(Phone, '') [Phone]
, isnull(Fax_Country, '') [Fax_Country], isnull(Fax_Area, '') [Fax_Area], isnull(Fax_No, '') [Fax_No]
, isnull(Email, '') [Email]
from Contact_Person

-- Auth_Sig_ID, Client_ID, Signing_Client_ID, First_Name, Surname, From_Date, To_Date
Select Auth_Sig_ID, Client_ID
, isnull(Signing_Client_ID, '') [Signing_Client_ID]
, isnull(First_Name, '') [First_Name]
, isnull(Surname, '') [Surname]
, isnull(convert(varchar(10), From_Date, 120), '') [From_Date]
, isnull(convert(varchar(10), To_Date, 120), '') [To_Date]
from Signing_Authority
  
=end
  
  def self.delete_index
    self.__elasticsearch__.client.indices.delete index: self.index_name rescue nil
  end
  
  def self.create_index
    self.__elasticsearch__.create_index! force: true
    self.__elasticsearch__.refresh_index!
  end
  
  def self.comparison
    self.all.each do |person|
      s = self.es.search "+full_name:#{person.full_name}"
      person.match s.hits
    end
  end
  
  def self.load(person: nil)
    types = {contact: :contact_id}
    id = types[person[:type]]
    p = self.where(id => person[id]).first
    if p
      p.update_me(person: person)
    else
      self.new.create_me(person: person)
    end
  end
  
  def create_me(person: nil)
    self.update_attrs(person: person)
    maintain_addresses(address_attrs: extract_address_attrs(person))
    self.save
    publish(:successful_person_create_event, self)
  end
  
  def update_me(person: nil)
    self.update_attrs(person: person)
    maintain_addresses(address_attrs: extract_address_attrs(person))    
    self.save
    publish(:successful_person_update_event, self)
  end
  
  
  def update_attrs(person: nil)
    person.each {|name, value| self.send("#{name}=", value) unless [:address_line_1, :address_line_2, :address_line_3, :city, :country, :post_code, :first_name, :surname].include? name}
    self.full_name = {first_name: person[:first_name], surname: person[:surname]}
  end
  
  def maintain_addresses(addresses)
    # there is no way to determine which address to update, so delete them first
    self.addresses.delete_all
    self.addresses << Address.create_me(addresses)
  end
  
  def extract_address_attrs(person)
    {
      address_line_1: person[:address_line_1],
      address_line_2: person[:address_line_2], 
      address_line_3: person[:address_line_3], 
      city: person[:city], 
      country: person[:country],
      post_code: person[:post_code],
      type: person[:type]
    }
    
  end
  
  def as_indexed_json(options={})
    as_json(except: [:id, :_id])
  end
  
  
  def full_name=(name)
    if name[:full_name]
      self[:full_name] = name[:full_name]
    else
      self[:full_name] = "#{name[:first_name]} #{name[:surname]}"
    end
  end
  
  def match(hits)
    own = 0
    hits.each do |hit|
      result = Hashie::Mash.new hit
      if result._id != self.id.to_s
        m = self.matches.where(matched_person: result._id).first
        if m
          m.update_attrs(result)
        else
          m = Match.create_me(result)
          self.matches << m
        end
        m.reducers
      else
        own = 1
      end
    end
    self.hits = hits.count - own
    save
  end
  
  def full_phone_number
    "#{phone_country} #{phone_area} #{phone}"
  end
  
  def full_fax_number
    "#{fax_country} #{fax_area} #{fax_no}"
  end
  
end
