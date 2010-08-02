require 'mocha/is_a'

module Mocha # :nodoc:
  
  class SingleReturnBlock # :nodoc:
    
    def initialize(value)
      @value = value
    end
    
    def evaluate(*args)
      @value.call(*args)
    end
    
  end
  
end
