class Matchers
  
  class << self
    def register_matchers(*matchers)
      matchers.each do |matcher|
        define_method(matcher) do
          matcher.to_s.split("_").collect(&:capitalize).join.constantize.new  # create a method for the matcher that is a constructor
        end
      end
    end
  end
  
  register_matchers :city_matcher, :client_id_matcher, :postal_address_matcher, :email_matcher, :full_name_matcher
  
  def matchers
    self.methods.select {|m| m[/_matcher/]}
  end
  
  def process(person: nil, potential: nil)
    self.matchers.inject({}) do |matchers, matcher|
      result = self.send(matcher).match(person: person, potential: potential)
      matchers[result[:matcher]] = result[:match]
      matchers
    end
  end
    
  
end