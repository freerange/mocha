require 'mocha/singleton_class'

module Mocha
  module ObjectMethods
    def define_instance_method(method_symbol, &block)
      singleton_class.send(:define_method, method_symbol, block)
    end

    def replace_instance_method(method_symbol, &block)
      raise "Cannot replace #{method_symbol} as #{self} does not respond to it." unless respond_to?(method_symbol)
      define_instance_method(method_symbol, &block)
    end

    def define_instance_accessor(*symbols)
      symbols.each { |symbol| singleton_class.send(:attr_accessor, symbol) }
    end
  end
end

class Object
  include Mocha::ObjectMethods
end
