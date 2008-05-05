require 'mocha/is_a'
require 'mocha/deprecation'

module Mocha # :nodoc:
  
  class SingleReturnValue # :nodoc:
    
    def initialize(value)
      @value = value
    end
    
    def evaluate
      @value
    end
    
  end
  
end
