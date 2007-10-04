require 'mocha/inspect'

module Mocha
  
  class Parameters
    
    def initialize(parameters)
      @parameters = parameters
    end
    
    def ==(parameters)
      (@parameters == parameters)
    end
    
    def to_s
      text = @parameters.mocha_inspect
      text = text.gsub(/^\[|\]$/, '')
      text = text.gsub(/^\{|\}$/, '') if @parameters.length == 1
      "(#{text})"
    end
    
  end

  class AnyParameters
    
    def ==(parameters)
      true
    end
    
    def to_s
      ""
    end
    
  end

end