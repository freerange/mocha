require 'mocha/configuration'
require 'mocha/parameter_matchers/base'

module Mocha
  module ParameterMatchers
    class PositionalOrKeywordHash < Base
      # @private
      def initialize(value)
        @value = value
      end

      # @private
      def matches?(available_parameters)
        parameter = available_parameters.shift
        if Mocha.configuration.strict_keyword_argument_matching? && available_parameters.empty?
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
