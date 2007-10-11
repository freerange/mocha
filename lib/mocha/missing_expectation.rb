require 'mocha/expectation'

module Mocha # :nodoc:
  
  class MissingExpectation < Expectation # :nodoc:

    def verify
      msg = error_message(0, 1)
      similar_expectations_list = method_signature.similar_method_signatures.join("\n")
      msg << "\nSimilar expectations:\n#{similar_expectations_list}" unless similar_expectations_list.empty?
      raise ExpectationError.new(msg, backtrace)
    end

  end

end