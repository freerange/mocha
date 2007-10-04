require 'mocha/pretty_parameters'

module Mocha
  
  class Parameters
    def initialize(parameters)
      @parameters = parameters
    end
    def ==(parameters)
      (@parameters == parameters)
    end
    def to_s
      "(#{PrettyParameters.new(@parameters).pretty})"
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