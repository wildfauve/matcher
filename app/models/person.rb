class Person
  
  include Wisper::Publisher

  include Mongoid::Document
  include Mongoid::Timestamps  
  
  field :type, type: Symbol # contact_person
  field :contact_iD, type: String # contact_person
  field :client_iD, type: String # contact_person
  field :first_name, type: String # contact_person
  field :surname, type: String # contact_person
  field :relationship, type: String # contact_person
  field :department, type: String # contact_person
  field :phone_area, type: String # contact_person
  field :phone, type: String # contact_person
  field :phone_country, type: String # contact_person
  field :fax_area, type: String # contact_person
  field :fax_no, type: String # contact_person
  field :fax_country,type: String # contact_person
  field :email, type: String # contact_person
  
  embeds_one :address

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
  
  def create_me(green_kiwi: nil, id_attrs: nil, user_proxy: nil)
    self.update_attrs(green_kiwi: green_kiwi, id_attrs: id_attrs, user_proxy: user_proxy)
    self.save
    publish(:successful_green_kiwi_create_event, self)
  end
  
  def update_me(green_kiwi: nil, id_attrs: nil)
    self.update_attrs(green_kiwi: green_kiwi, id_attrs: id_attrs)
    self.save
    publish(:successful_green_kiwi_update_event, self)
  end
  
  
  def update_attrs(green_kiwi: green_kiwi, id_attrs: id_attrs, user_proxy: nil)
    self.user_proxy = user_proxy if self.user_proxy != user_proxy || !user_proxy.nil?
    self.kiwi_url = green_kiwi[:kiwi_url]
    add_profile_entries(id_attrs: id_attrs)
    
  end
  
  
end
