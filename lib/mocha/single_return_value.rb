require 'mocha/is_a'

module Mocha # :nodoc:
  
  class SingleReturnValue # :nodoc:
    
    def initialize(value)
      @value = value
    end
    
    def evaluate
      if @value.is_a?(Proc)
        @value.call
      else
        @value
      end
    end
    
  end
  
end
