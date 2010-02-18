module Mocha
  
  module ParameterMatchers
    
    class Base # :nodoc:
      
      def to_matcher
        self
      end
      
      def &(matcher)
        AllOf.new(self, matcher)
      end
      
      def |(matcher)
        AnyOf.new(self, matcher)
      end
      
    end
    
  end
  
end
