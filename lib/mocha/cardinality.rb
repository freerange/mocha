module Mocha

  class Cardinality
    
    INFINITE = 1 / 0.0
    
    class << self
      
      def exactly(count)
        new(count, count)
      end
      
      def at_least(count)
        new(count, INFINITE)
      end
      
      def at_most(count)
        new(-INFINITE, count)
      end
      
      def times(range_or_count)
        case range_or_count
        when Range
          new(range_or_count.first, range_or_count.last)
        else
          new(range_or_count, range_or_count)
        end
      end
      
    end
    
    def initialize(required, maximum)
      @required, @maximum = required, maximum
    end
    
    def invocations_allowed?(invocation_count)
      invocation_count < @maximum
    end
    
    def satisfied?(invocations_so_far)
      invocations_so_far >= @required
    end
    
    def verified?(invocation_count)
      (invocation_count >= @required) && (invocation_count <= @maximum)
    end
    
    def mocha_inspect
      if @required.respond_to?(:infinite?) && @required.infinite?
        "at most #{@maximum}"
      elsif @maximum.respond_to?(:infinite?) && @maximum.infinite?
        "at least #{@required}"
      elsif @required == @maximum
        "#{@required}"
      else
        "#{@required}..#{@maximum}"
      end
    end

  end
  
end
