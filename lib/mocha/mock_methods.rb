require 'mocha/expectation'

module Mocha
  module MockMethods
  
    def expectations
      @expectations ||= []
    end

    def expects(symbol)
      expectations << Expectation.new(symbol)
      expectations.last
    end

    def stubs(symbol)
      expectations << Stub.new(symbol)
      expectations.last
    end

    def method_missing(symbol, *arguments, &block)
      matching_expectation = matching_expectation(symbol, *arguments)
      if matching_expectation then
        matching_expectation.invoke
      else
        begin
          super_method_missing(symbol, *arguments, &block)
    		rescue NoMethodError
    			unexpected_method_called(symbol, *arguments)
    		end
  		end
  	end
	
  	def super_method_missing(symbol, *arguments, &block)
  	  raise NoMethodError
    end

  	def unexpected_method_called(symbol, *arguments)
      MissingExpectation.new(symbol, expectations).with(*arguments).verify
    end
	
  	def matching_expectation(symbol, *arguments)
      expectations.detect { |expectation| expectation.match?(symbol, *arguments) }
    end
  
    def verify(&block)
      expectations.each { |expectation| expectation.verify(&block) }
    end
  
  end
end