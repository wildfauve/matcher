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
  
  def self.extract_address_attrs(person)
    if person[:type] == :client
      addresses = []
      ["physical", "postal"].each do |a_type|
        addresses << person.keys.select { |key| key.to_s.match(/^#{a_type}/) }.
                        inject({type: a_type.to_sym}) {|addr, key| addr[key.to_s.gsub("#{a_type}_", "").to_sym] = person[key]; addr}
      end
      addresses
    else
      [{
        address_line_1: person[:address_line_1],
        address_line_2: person[:address_line_2], 
        address_line_3: person[:address_line_3], 
        city: person[:city], 
        country: person[:country],
        post_code: person[:post_code],
        type: :postal
      }]
    end
  end  
  
  def self.create_me(addr: nil)
    a = self.new.update_attrs(address_attrs: addr)
    a
  end
  
  def update_attrs(address_attrs: nil)
    address_attrs.each {|name, value| self.send("#{name}=", value)}
    self
  end
  
  def self.has_address?(addresses)
    addresses[:address_line_1].nil? ? false : true
  end
  
  
end