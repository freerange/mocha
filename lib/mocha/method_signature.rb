require 'mocha/inspect'

module Mocha
  
  class MethodSignature
    
    attr_reader :method_name
    
    def initialize(method_name, parameters = nil, &block)
      @method_name, @parameters, @block = method_name, parameters, block
    end
    
    def modify(parameters = nil, &block)
      @parameters, @block = parameters, block
    end
    
    def match?(method_name, parameters)
      (@method_name == method_name) && (@parameters.nil? || (@block && @block.call(*parameters)) || (@parameters == parameters))
    end
    
    def to_s
      if @parameters then
        text = @parameters.mocha_inspect
        text = text.gsub(/^\[|\]$/, '')
        text = text.gsub(/^\{|\}$/, '') if @parameters.length == 1
        "#{@method_name}(#{text})"
      else
        "#{@method_name}"
      end
    end
    
  end

end