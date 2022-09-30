require 'mocha/configuration'
require 'mocha/parameter_matchers/base'

module Mocha
  module ParameterMatchers
    # @private
    class PositionalOrKeywordHash < Base
      def initialize(value)
        @value = value
      end

      def matches?(available_parameters)
        parameter, is_last_parameter = extract_parameter(available_parameters)
        if is_last_parameter && Mocha.configuration.strict_keyword_argument_matching?
          return false unless ::Hash.ruby2_keywords_hash?(parameter) == ::Hash.ruby2_keywords_hash?(@value)
        end
        parameter == @value
      end

      def mocha_inspect
        @value.mocha_inspect
      end

      private

      def extract_parameter(available_parameters)
        [available_parameters.shift, available_parameters.empty?]
      end
    end
  end
end
