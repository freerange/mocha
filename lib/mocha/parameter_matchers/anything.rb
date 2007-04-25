module Mocha
  module ParameterMatchers

    def anything
      Anything.new
    end
    
    class Anything
    
      def ==(parameter)
        return true
      end
      
      def mocha_inspect
        "anything"
      end
      
    end
    
  end
end