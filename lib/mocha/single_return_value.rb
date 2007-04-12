require 'mocha/is_a'

module Mocha # :nodoc:
  
  class SingleReturnValue # :nodoc:
    
    def initialize(value)
      @value = value
    end
    
    def evaluate
      if @value.__is_a__(Proc) then
        @value.call
      else
        @value
      end
    end
    
  end
  
end