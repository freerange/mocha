# frozen_string_literal: true

require 'mocha/parameter_matchers/base_methods'

module Mocha
  module ParameterMatchers
    module Methods
      # Matches if +matcher+ does *not* match.
      #
      # @param [BaseMethods] matcher matcher whose logic to invert.
      # @return [Not] parameter matcher.
      #
      # @see Expectation#with
      #
      # @example Actual parameter does not include the value +1+.
      #   object = mock()
      #   object.expects(:method_1).with(Not(includes(1)))
      #   object.method_1([0, 2, 3])
      #   # no error raised
      #
      # @example Actual parameter does include the value +1+.
      #   object = mock()
      #   object.expects(:method_1).with(Not(includes(1)))
      #   object.method_1([0, 1, 2, 3])
      #   # error raised, because method_1 was not called with object not including 1
      #
      def Not(matcher) # rubocop:disable Naming/MethodName
        Not.new(matcher)
      end
    end

    # Parameter matcher which inverts the logic of the specified matcher using a logical NOT operation.
    class Not
      include BaseMethods

      # @private
      def initialize(matcher)
        @matcher = matcher
      end

      # @private
      def matches?(available_parameters)
        parameter = available_parameters.shift
        !@matcher.matches?([parameter])
      end

      # @private
      def mocha_inspect
        "Not(#{@matcher.mocha_inspect})"
      end
    end
  end
end
