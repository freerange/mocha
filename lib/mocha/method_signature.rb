require 'mocha/inspect'

module Mocha
  
  class MethodSignature
    
    attr_reader :method_name
    
    def initialize(mock, method_name, parameters = nil, &block)
      @mock, @method_name, @parameters, @block = mock, method_name, parameters, block
    end
    
    def modify(parameters = nil, &block)
      @parameters, @block = parameters, block
    end
    
    def match?(method_name, parameters)
      (@method_name == method_name) && (@parameters.nil? || (@block && @block.call(*parameters)) || (@parameters == parameters))
    end
    
    def similar_method_signatures
      @mock.similar_expectations(@method_name).collect { |expectation| expectation.method_signature }
    end
    
    def parameter_signature
      return "" unless @parameters
      signature = @parameters.mocha_inspect
      signature = signature.gsub(/^\[|\]$/, '')
      signature = signature.gsub(/^\{|\}$/, '') if @parameters.length == 1
      "(#{signature})"
    end
    
    def to_s
      "#{@mock.mocha_inspect}.#{@method_name}#{parameter_signature}"
    end
    
  end

end