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
  
  register_matchers :address_matcher, :client_id_matcher
  
  def matchers
    self.methods.select {|m| m[/_matcher/]}
  end
  
  def process(person: nil, potential: nil)
    self.matchers.inject([]) do |matchers, matcher|
      matchers << self.send(matcher).match(person: person, potential: potential)
    end
  end
  
  def profile_change(profile: nil)
    profile.inject([]) do |extensions, item| 
      extensions << self.send(item.id_attribute.extender).execute(item: item, profile: profile)
    end.flatten.uniq
  end
  
  #def profile_change(profile: nil)
  # extenders.each do |extender|
  #    self.send(extender).execute(profile: profile)
  #  end
  #end
  
  
end