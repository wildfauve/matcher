class Setting
  
  include Wisper::Publisher

  include Mongoid::Document
  include Mongoid::Timestamps  
  
  field :name, type: String
  field :value_int, type: Integer
  field :value_float, type: Float  
  field :value_string, type: String
  field :type, type: Symbol
  
  def self.types
    [["String", :string], ["Integer", :integer], ["Float", :float]]
  end
  
  def self.value_for(name)
    set = Setting.where(name: name).first
    set.nil? ? nil : set.value
  end    
    
  def create_me(config: nil)
    update_attrs(config: config)
    self.save
    publish(:successful_setting_create_event, self)
  end

  def update_me(config: nil)
    update_attrs(config: config)
    self.save
    publish(:successful_setting_update_event, self)
  end
  
  def value
    case self.type
    when :string
      self.value_string
    when :integer
      self.value_int
    when :float
      self.value_float
    else
      raise
    end
  end
  
  def update_attrs(config: nil)
    self.name = config[:name]
    self.type = config[:type]
    case self.type
    when :string
      self.value_string = config[:value]
    when :integer
      self.value_int = config[:value].to_i
    when :float
      self.value_float = config[:value].to_f      
    else
      raise
    end
  end  
  
end
