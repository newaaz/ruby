module Accessors
  def attr_accessor_with_history(*attributes)        
    attributes.each do |attribute|
      attr_name = "@#{attribute}".to_sym
      # getter
      define_method(attribute) { instance_variable_get(attr_name) }
      # setter
      define_method("#{attribute}=") do |value|                   
        instance_variable_set(attr_name, value)          
        @attributes_history ||= {}
        attribute_history = @attributes_history[attribute.to_sym] || []
        attribute_history << value
        @attributes_history[attribute.to_sym] = attribute_history          
      end
      # attributes history
      define_method("#{attribute}_history") { @attributes_history[attribute.to_sym] }
    end
  end

  def strong_attr_accessor(attribute, type)
    attr_name = "@#{attribute}".to_sym
    define_method(attribute) { instance_variable_get(attr_name) }
    #setter
    define_method("#{attribute}=") do |value|
      raise TypeError.new("Значение не является типом #{type.to_s}") unless value.class == type
      instance_variable_set(attr_name, value)
    rescue TypeError => e
      puts e.message
    end    
  end  
end
