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
        return false unless Hash.ruby2_keywords_hash?(parameter) && Hash.ruby2_keywords_hash?(@value)

        parameter == @value
      end

      # @private
      def mocha_inspect
        @value.mocha_inspect
      end
    end
  end
end
