module Mocha
  
  module ParameterMatchers

    # :call-seq: any_of -> parameter_matcher
    def any_of(*matchers)
      AnyOf.new(*matchers)
    end
    
    class AnyOf # :nodoc:
      
      def initialize(*matchers)
        @matchers = matchers
      end
    
      def ==(parameter)
        @matchers.any? { |matcher| matcher == parameter }
      end
      
      def mocha_inspect
        "any_of(#{@matchers.map { |matcher| matcher.mocha_inspect }.join(", ") })"
      end
      
    end
    
  end
  
end