require 'mocha/inspect'
require 'mocha/parameter_matchers'

module Mocha
  
  class MethodSignature
    
    attr_reader :method_name
    
    def initialize(mock, method_name, parameters = [ParameterMatchers::AnyParameters.new], &matching_block)
      @mock, @method_name, @parameters, @matching_block = mock, method_name, parameters, matching_block
    end
    
    def modify(parameters = [ParameterMatchers::AnyParameters.new], &matching_block)
      @parameters, @matching_block = parameters, matching_block
    end
    
    def match?(actual_method_name, actual_parameters = [])
      return false unless (@method_name == actual_method_name)
      if @matching_block
        return @matching_block.call(*actual_parameters)
      else
        return parameters_match?(actual_parameters)
      end
    end
    
    def parameters_match?(actual_parameters)
      matchers.all? { |matcher| matcher.matches?(actual_parameters) } && (actual_parameters.length == 0)
    end
    
    def similar_method_signatures
      @mock.similar_expectations(@method_name).collect { |expectation| expectation.method_signature }
    end
    
    def parameter_signature
      signature = matchers.mocha_inspect
      signature = signature.gsub(/^\[|\]$/, '')
      signature = signature.gsub(/^\{|\}$/, '') if matchers.length == 1
      "(#{signature})"
    end
    
    def to_s
      "#{@mock.mocha_inspect}.#{@method_name}#{parameter_signature}"
    end
    
    def matchers
      @parameters.map { |parameter| parameter.to_matcher }
    end
    
  end

end