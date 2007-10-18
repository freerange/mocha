require 'mocha/inspect'

module Mocha
  
  class MethodSignature
    
    attr_reader :method_name
    
    def initialize(mock, method_name, parameters = nil, &matching_block)
      @mock, @method_name, @parameters, @matching_block = mock, method_name, parameters, matching_block
    end
    
    def modify(parameters = nil, &matching_block)
      @parameters, @matching_block = parameters, matching_block
    end
    
    def match?(actual_method_name, actual_parameters = nil)
      (@method_name == actual_method_name) && ((@matching_block.nil? && @parameters.nil?) || (@matching_block && @matching_block.call(*actual_parameters)) || (@parameters == actual_parameters))
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