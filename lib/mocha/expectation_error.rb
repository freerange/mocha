module Mocha
  # Default exception class raised when an unexpected invocation or an unsatisfied expectation occurs.
  #
  # Authors of test libraries may use +Mocha::ExpectationErrorFactory+ to have Mocha raise a different exception.
  #
  # @see Mocha::ExpectationErrorFactory
  # rubocop:disable Lint/InheritException
  class ExpectationError < Exception; end
  # rubocop:enable Lint/InheritException
end
