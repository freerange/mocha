module Mocha # :nodoc:

  class ExpectationList

    def initialize
      @expectations = []
    end
    
    def add(expectation)
      @expectations << expectation
      expectation
    end
    
    def matches_method?(method_name)
      @expectations.any? { |expectation| expectation.matches_method?(method_name) }
    end
    
    def detect(method_name, *arguments)
      expectations = @expectations.reverse.select { |e| e.match?(method_name, *arguments) }
      expectation = expectations.detect { |e| e.invocations_allowed? }
      expectation || expectations.first
    end
    
    def verified?(assertion_counter = nil)
      @expectations.all? { |expectation| expectation.verified?(assertion_counter) }
    end
    
    def to_a
      @expectations
    end
    
    def to_set
      @expectations.to_set
    end
    
    def length
      @expectations.length
    end
    
  end

end
