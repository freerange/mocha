module Mocha
  
  module ParameterMatchers

    # :call-seq: all_of -> parameter_matcher
    def all_of(*matchers)
      AllOf.new(*matchers)
    end
    
    class AllOf # :nodoc:
      
      def initialize(*matchers)
        @matchers = matchers
      end
    
      def ==(parameter)
        @matchers.all? { |matcher| matcher == parameter }
      end
      
      def mocha_inspect
        "all_of(#{@matchers.map { |matcher| matcher.mocha_inspect }.join(", ") })"
      end
      
    end
    
  end
  
end