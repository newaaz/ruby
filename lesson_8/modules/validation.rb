module Validation
  def self.included(base)
     base.extend ClassMethods
     base.include InstanceMethods
  end

  module ClassMethods
    def validate(inst_var, type_validation, *arg)
      @validates ||= []
      @validates << { inst_var: inst_var, type_validation: type_validation, arg: arg }    
    end
  end

  module InstanceMethods
    def valid?
      validate!
      true
    rescue
      false
    end

    protected

    def validate! 
      self.class.instance_variable_get("@validates").each do |validate|
        name = validate[:inst_var]
        value = instance_variable_get "@#{name}"
        arg = validate[:arg][0]
        send "validate_#{validate[:type_validation]}", name, value, arg
      end
    end

    def validate_presence(name, value, _)
      raise "#{name} не может быть пустым" if value.empty?
    end

    def validate_length(name, value, arg)
      raise "#{name} должен содержать не меньше #{arg} символов" if value.length < arg
    end

    def validate_format(name, value, regexp)
      raise "#{name} #{value} не соответствует формату" if value !~ regexp
    end
  end
end