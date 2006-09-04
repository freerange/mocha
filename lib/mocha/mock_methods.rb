require 'mocha/expectation'

module Mocha
  # Methods added to mock objects.
  # These methods all return an expectation which can be further modified by methods on Mocha::Expectation.
  module MockMethods
    
    # :stopdoc:
    
    attr_reader :stub_everything
  
    def expectations
      @expectations ||= []
    end

    # :startdoc:

    # :call-seq: expects(symbol) -> expectation
    #
    # Adds an expectation that a method identified by +symbol+ must be called exactly once with any parameters.
    def expects(symbol, backtrace = nil)
      expectations << Expectation.new(symbol, backtrace)
      expectations.last
    end

    # :call-seq: stubs(symbol) -> expectation
    #
    # Adds an expectation that a method identified by +symbol+ may be called any number of times with any parameters.
    def stubs(symbol, backtrace = nil)
      expectations << Stub.new(symbol, backtrace)
      expectations.last
    end
    
    # :stopdoc:

    def method_missing(symbol, *arguments, &block)
      matching_expectation = matching_expectation(symbol, *arguments)
      if matching_expectation then
        matching_expectation.invoke(&block)
      elsif stub_everything then
        return
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
      MissingExpectation.new(symbol, self, expectations).with(*arguments).verify
    end
	
  	def matching_expectation(symbol, *arguments)
      expectations.detect { |expectation| expectation.match?(symbol, *arguments) }
    end
  
    # :startdoc:

    # :call-seq: verify
    # 
    # Asserts that all expectations have been fulfilled.
    # Called automatically at the end of a test for mock objects created by methods in Mocha::AutoVerify.
    def verify(&block)
      expectations.each { |expectation| expectation.verify(&block) }
    end
  
  end
end