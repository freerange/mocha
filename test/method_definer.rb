require 'mocha/metaclass'

class Object
  
  def define_instance_method(method_symbol, &block)
    metaclass.send(:define_method, method_symbol, block)
  end

  def replace_instance_method(method_symbol, &block)
    raise "Cannot replace #{method_symbol} as #{self} does not respond to it." unless self.respond_to?(method_symbol)
    define_instance_method(method_symbol, &block)
  end

  def define_instance_accessor(*symbols)
    symbols.each { |symbol| metaclass.send(:attr_accessor, symbol) }
  end

end