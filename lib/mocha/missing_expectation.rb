require 'mocha/expectation'
require 'mocha/cardinality'

module Mocha # :nodoc:
  
  class MissingExpectation < Expectation # :nodoc:

    def verify
      message = "unexpected invocation: #{method_signature}"
      similar_expectations = @mock.expectations.similar(@method_matcher.expected_method_name)
      expectation_descriptions = similar_expectations.map { |expectation| expectation.mocha_inspect }
      message << "\nSimilar expectations:\n#{expectation_descriptions.join("\n")}" unless expectation_descriptions.empty?
      raise ExpectationError.new(message, backtrace)
    end

  end

end