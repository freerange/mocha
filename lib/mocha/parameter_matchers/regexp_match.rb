module Mocha
  
  module ParameterMatchers

    # :call-seq: regexp_match(regexp) -> parameter_matcher
    #
    # Matches any object that matches the regular expression
    #   object = mock()
    #   object.expects(:method_1).with(regexp_match(/e/))
    #   object.method_1('hello')
    #   # no error raised
    #
    #   object = mock()
    #   object.expects(:method_1).with(regexp_match(/a/))
    #   object.method_1('hello')
    #   # error raised, because method_1 was not called with a parameter that matched the 
    #   # regular expression
    def regexp_match(regexp)
      RegexpMatcher.new(regexp)
    end

    class RegexpMatcher # :nodoc:
  
      def initialize(regexp)
        @regexp = regexp
      end
  
      def ==(parameter)
        parameter =~ @regexp
      end
  
      def mocha_inspect
        "regexp_match(#{@regexp.mocha_inspect})"
      end
  
    end
    
  end
  
end
