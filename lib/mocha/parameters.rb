require 'mocha/inspect'

module Mocha
  
  class Parameters
    
    def initialize(parameters = nil, &block)
      @parameters, @block = parameters, block
    end
    
    def match?(parameters)
      @parameters.nil? || (@block && @block.call(*parameters)) || (@parameters == parameters)
    end
    
    def to_s
      if @parameters then
        text = @parameters.mocha_inspect
        text = text.gsub(/^\[|\]$/, '')
        text = text.gsub(/^\{|\}$/, '') if @parameters.length == 1
        "(#{text})"
      else
        ""
      end
    end
    
  end

end