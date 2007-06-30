module Mocha # :nodoc:

  class ExpectationList

    def initialize
      @expectations = []
    end

    def add(expectation)
      @expectations << expectation
    end

    def respond_to?(method_name)
      @expectations.any? { |expectation| expectation.method_name == method_name }
    end

    def detect(method_name, *arguments)
      expectations = @expectations.reverse.select { |expectation| expectation.match?(method_name, *arguments) }
      expectation = expectations.detect { |expectation| expectation.invocations_allowed? }
      expectation || expectations.first
    end

    def similar(method_name)
      @expectations.select { |expectation| expectation.method_name == method_name }
    end

    def verify(&block)
      @expectations.each { |expectation| expectation.verify(&block) }
    end

    def to_a
      @expectations
    end

    def to_set
      @expectations.to_set
    end

    def size
      @expectations.size
    end

  end

end
