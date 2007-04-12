module Mocha # :nodoc:
  
  class ExceptionRaiser # :nodoc:
    
    def initialize(exception, message)
      @exception, @message = exception, message
    end
    
    def evaluate
      if @message then
        raise @exception, @message
      else
        raise @exception
      end
    end
    
  end
  
end
