module Mocha

  # Exception raised when an unexpected method is invoked
  class UnexpectedInvocation

    # @private
    def initialize(mock, symbol, *arguments)
      @mock = mock
      @method_matcher = MethodMatcher.new(symbol)
      @parameters_matcher = ParametersMatcher.new(arguments)
    end

    # @private
    def to_s
      method_signature = "#{@mock.mocha_inspect}.#{@method_matcher.mocha_inspect}#{@parameters_matcher.mocha_inspect}"
      "unexpected invocation: #{method_signature}\n"
    end

  end

end
