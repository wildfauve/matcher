class Address

  include Mongoid::Document
  include Mongoid::Timestamps  
  
  field :address_line_1, type: String
  field :address_line_2, type: String  
  field :address_line_3, type: String
  field :city, type: String
  field :country, type: String
  field :post_code, type: String
  field :type
  
  embedded_in :person
  
  def self.create_me(address_attrs: nil)
    a = self.new.update_attrs(address_attrs: address_attrs)
    a
  end
  
  def update_attrs(address_attrs: nil)
    address_attrs.each {|name, value| self.send("#{name}=", value)}
    self
  end
  
end