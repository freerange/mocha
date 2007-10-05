require 'mocha/expectation'

module Mocha # :nodoc:
  
  class MissingExpectation < Expectation # :nodoc:

    def initialize(mock, method_name)
      super
      @invoked_count = true
    end

    def verify
      msg = error_message(0, 1)
      similar_expectations_list = method_signature.similar_method_signatures.join("\n")
      msg << "\nSimilar expectations:\n#{similar_expectations_list}" unless similar_expectations_list.empty?
      error = ExpectationError.new(msg, backtrace)
      raise error if @invoked_count
    end

  end

end