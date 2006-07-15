require 'mocha/mock_methods'

module Mocha

  class MockClass
  
    include MockMethods

    class << self
    
      include MockMethods
    
      def super_method_missing(symbol, *arguments, &block)
        superclass.method_missing(symbol, *arguments, &block)
      end
        
      alias_method :__new__, :new
  
      def new(*arguments, &block)
        method_missing(:new, *arguments, &block)
      end
        
      def inherited(subclass)
        subclass.class_eval do

          def self.new(*arguments, &block)
            __new__(*arguments, &block)
          end
        
        end
      
      end
    
    end  
  
  end

end