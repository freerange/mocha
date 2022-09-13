require 'mocha/parameter_matchers/base'

module Mocha
  module ParameterMatchers
    class Hash < Base
      # @private
      def initialize(value)
        @value = value
      end

      # @private
      def matches?(available_parameters)
        parameter = available_parameters.shift
        # we can insert a check for a configuration here
        if available_parameters.empty? # last parameter
          return false unless ::Hash.ruby2_keywords_hash?(parameter) == ::Hash.ruby2_keywords_hash?(@value)
        end
        parameter == @value
      end

      # @private
      def mocha_inspect
        @value.mocha_inspect
      end
    end
  end
end
