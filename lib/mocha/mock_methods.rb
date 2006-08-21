require 'mocha/expectation'

module Mocha
  module MockMethods
  
    def expectations
      @expectations ||= []
    end

    def expects(symbol, backtrace = nil)
      expectations << Expectation.new(symbol, backtrace)
      expectations.last
    end

    def stubs(symbol, backtrace = nil)
      expectations << Stub.new(symbol, backtrace)
      expectations.last
    end

    def method_missing(symbol, *arguments, &block)
      matching_expectation = matching_expectation(symbol, *arguments)
      if matching_expectation then
        matching_expectation.invoke(&block)
      else
        begin
          super_method_missing(symbol, *arguments, &block)
    		rescue NoMethodError
    			unexpected_method_called(symbol, *arguments)
    		end
  		end
  	end
  	
  	def respond_to?(symbol)
  	  expectations.any? { |expectation| expectation.method_name == symbol }
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