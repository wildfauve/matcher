class Address

  include Mongoid::Document
  include Mongoid::Timestamps  
  
  field :address_line_1, type: String
  field :address_Line_2, type: String
  field :address_Line_3, type: String
  field :city, type: String
  field :country, type: String
  field :post_code, type: String
  
end