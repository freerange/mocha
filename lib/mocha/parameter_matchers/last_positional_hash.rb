require 'mocha/parameter_matchers/base'

module Mocha
  module ParameterMatchers
    # Parameter matcher which matches when actual parameter equals expected value.
    class LastPositionalHash < Base
      # @private
      def initialize(value)
        @value = value
      end

      # @private
      def matches?(available_parameters)
        parameter = available_parameters.shift
        return false if Hash.ruby2_keywords_hash?(@value) && !Hash.ruby2_keywords_hash?(parameter)

        parameter == @value
      end

      # @private
      def mocha_inspect
        @value.mocha_inspect
      end
    end
  end
end
