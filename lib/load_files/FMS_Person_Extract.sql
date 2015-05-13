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

