# frozen_string_literal: true

require 'mocha/parameter_matchers/base_methods'

module Mocha
  module ParameterMatchers
    module Methods
      # Matches any object.
      #
      # @return [Anything] parameter matcher.
      #
      # @see Expectation#with
      #
      # @example Any object will match.
      #   object = mock()
      #   object.expects(:method_1).with(anything)
      #   object.method_1('foo')
      #   object.method_1(789)
      #   object.method_1(:bar)
      #   # no error raised
      def anything
        Anything.new
      end
    end

    # Parameter matcher which always matches a single parameter.
    class Anything
      include BaseMethods

      # @private
      def matches?(available_parameters)
        available_parameters.shift
        true
      end

      # @private
      def mocha_inspect
        'anything'
      end
    end
  end
end
