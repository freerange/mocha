require 'mocha/parameter_matchers/base'

module Mocha

  module ParameterMatchers

    # Matches based on a +Proc+ or +lambda+.
    #
    # @param [Proc] fn function that returns true or false.
    # @return [MatchesFn] parameter matcher.
    #
    # @see Expectation#with
    # @see Kernel#is_a?
    #
    # @example
    #   object = mock()
    #   object.expects(:method_1).with(matches_fn( ->(arg) { arg < 200 } ))
    #   object.method_1(99)
    #   # no error raised
    #
    def matches_fn(fn)
      MatchesFn.new(fn)
    end

    class MatchesFn < Base
      def initialize(fn)
        @fn = fn
      end

      def matches?(available_parameters)
        parameter = available_parameters.shift
        @fn.call(parameter)
      end

      def mocha_inspect
        "matches_fn()"
      end
    end

  end

end
