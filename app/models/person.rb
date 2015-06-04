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

  field :auth_sig_id, type: String # signing_auth  
  field :contact_id, type: String # contact_person
  field :client_id, type: String # contact_person, legal_party, client
  field :communication_type, type: String # contact_person, legal_party, client
  field :department, type: String # contact_person
  field :dob, type: Date # legal_party, client
  field :deceased_date, type: Date # legal_party
  field :email, type: String # contact_person, client 
  field :fax_area, type: String # contact_person
  field :fax_no, type: String # contact_person
  field :fax_country, type: String # contact_person  
  field :from_date, type: Date # signing_auth    
  field :full_name, type: String # agg(first_name, surname), contact_person, legal_party, client  
  field :gender, type: String # legal_party
  field :hits, type: Integer  
  field :legal_party_id, type: String # legal_party
  field :legal_name, type: String # client  
  field :perferred_name, type: String # legal party, client
  field :phone_area, type: String # contact_person
  field :phone, type: String # contact_person
  field :phone_country, type: String # contact_person
  field :relationship, type: String # contact_person
  field :signing_client_id, type: String # signing_auth    
  field :title, type: String # legal_party
  field :to_date, type: Date # signing_auth    
  field :type, type: Symbol
  
  embeds_many :addresses
  
  embeds_many :matches  
  

=begin
  
select c.Client_ID, Client_Type, Legal_Name, isnull(Title, '') [Title], First_Names, Surname, isnull(Preferred_Name, '') [Preferred_Name]
, isnull(convert(varchar(10), Commencement_Date, 120), '') as DOB, isnull(e.Email, '') [Email]
, isnull(addr.Communication_Type, '') [Communication_Type], isnull(addr.Postal_Address_Line_1, '') [Postal_Address_Line_1]
, isnull(addr.Postal_Address_Line_2, '') [Postal_Address_Line_2], isnull(addr.Postal_Address_Line_3, '') [Postal_Address_Line_3]
, isnull(addr.Postal_City, '') [Postal_City], isnull(addr.Postal_Country, '') [Postal_Country], isnull(addr.Postal_Post_Code, '') [Postal_Post_Code]
, isnull(addr.Physical_Address_Line_1, '') [Physical_Address_Line_1], isnull(addr.Physical_Address_Line_2, '') [Physical_Address_Line_2]
, isnull(addr.Physical_Address_Line_3, '') [Physical_Address_Line_3], isnull(addr.Physical_City, '') [Physical_City]
, isnull(addr.Physical_Country, '') [Physical_Country], isnull(addr.Physical_Post_Code, '') [Physical_Post_Code]
from Client c

-- Client_ID, Legal_Party_ID, First_Name, Surname, Preferred_Name, Title, DOB, Gender, Deceased_Date
select Client_ID, Legal_Party_ID, First_Name, Surname
, isnull(Preferred_Name, '') [Preferred_Name]
, isnull(Title, '') [Title]
, isnull(convert(varchar(10), DOB, 120), '') as DOB
, isnull(Gender, '') [Gender]
, isnull(convert(varchar(10), Deceased_Date, 120), '') [Deceased_Date]
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
    #self.__elasticsearch__.client.indices.delete index: self.index_name rescue nil
  end
  
  def self.create_index
    self.es.index_all  
  end
  
  def self.comparison
    self.all.each do |person|
      s = self.es.search(comp_search_dsl(person))
      #s = self.es.search "+full_name:#{person.full_name}"
      person.match s.hits
    end
  end
  
  def self.individual_comparison(person)
    self.es.search(comp_search_dsl(person))
  end
  
  def self.comp_search_dsl(person)
    {
      body: {
        query: {
          bool: {
            must_not: {
              match: {
                _id: person.id.to_s
              }
            },
            must: {
              match: {
                full_name: person.full_name
              }
            },
            should: {
              match: {
                email: person.email
              }
            },
            should: {
              match: {
                preferred_name: person.perferred_name
              }
            }            
          }
        }        
      }
    }
  end
  
  def self.load(person: nil)
    types = {contact: :contact_id, legal_party: :legal_party_id, client: :client_id}
    id = types[person[:type]]
    p = self.where(id => person[id]).first
    p ? p.update_me(person: person) : self.new.create_me(person: person)
  end
  
  def self.general_search(q: nil)
    self.es.search(
      {
        body: {
          query: {
            query_string: {
              query: q
            }          
          }
        }
      }
    )
  end
  
  def self.generate_download(people)
    Jbuilder.encode do |json| 
      json.status "ok"
      json.count people.count
      json.people people do |person|
        json.id person.id.to_s
        json.set! person.type_id_name, person.type_id_id
        json.client_id person.client_id
        json.type person.type
        json.full_name person.full_name
        json.total_matches person.matches.count
        json.filtered_matches person.matches.get_matches("true") do |match|
          json.score match.score
          #json.reducers match.reducers
          json.set! :reducers do
            match.reducers.each {|red| json.set! red["matcher"], red["match"] }
          end
          @dup = match.dup_person
          json.matched_person do 
            json.id @dup.id.to_s
            json.full_name @dup.full_name
            json.set! @dup.type_id_name, @dup.type_id_id
            json.client_id @dup.client_id
            json.type @dup.type
            json.full_name @dup.full_name

          end
        end
      end
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
    self.save
    publish(:successful_person_update_event, self)
  end
  
  
  def update_attrs(person: nil)
    person.each {|name, value| self.send("#{name}=", value) unless handled_attrs.include? name}
    maintain_addresses(address_attrs: Address.extract_address_attrs(person))
    self.full_name = {first_name: person[:first_name], surname: person[:surname]}
    self.dob = Date.parse(person[:dob]) if person[:dob]
    self.deceased_date = date_it(person[:deceased_date])
    self.from_date = date_it(person[:from_date])
    self.to_date = date_it(person[:to_date])
  end
  
  def date_it(date)
    Date.parse(date) if date
  end
  
  def handled_attrs
    [:address_line_1, :address_line_2, :address_line_3, 
      :city, :country, :post_code, 
      :first_name, :surname, :dob, :deceased_date, :from_date, :to_date,
      :client_type,
      :postal_address_line_1, :postal_address_line_2, :postal_address_line_3, :postal_city, :postal_country, :postal_post_code, 
      :physical_address_line_1,:physical_address_line_2, :physical_address_line_3, :physical_city, :physical_country, :physical_post_code
    ]
  end
  
  def maintain_addresses(addresses)
    # there is no way to determine which address to update, so delete them first
    self.addresses.delete_all
    addresses[:address_attrs].each {|addr| self.addresses << Address.create_me(addr: addr) }
  end
  
  
  def as_indexed_json(options={})
    as_json(except: [:id, :_id, :matches])
  end
  
  def match_decision(decision: nil, match: nil)
    m = self.matches.find(match).decision(decision)
    self.save
    publish(:successful_match_decision_event, self, m)
  end
  
  def match_decisions_count
    self.matches.select {|m| m.decision_made}.count
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
        m.run_reducers
      else
        own = 1
      end
    end
    self.hits = hits.count - own
    save
  end
  
  def type_id_id
    self.send(self.type_id_name)
  end
  
  def type_id_name
    case self.type
    when :contact
      :contact_id
    when :legal_party
      :legal_party_id
    when :client
      :client_id
    end
  end
    
  def full_phone_number
    "#{phone_country} #{phone_area} #{phone}"
  end
  
  def full_fax_number
    "#{fax_country} #{fax_area} #{fax_no}"
  end
    
end
