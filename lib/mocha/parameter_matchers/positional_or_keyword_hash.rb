require 'mocha/configuration'
require 'mocha/deprecation'
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
        return false unless parameter == @value

        if is_last_parameter && !same_type_of_hash?(parameter, @value)
          return false if Mocha.configuration.strict_keyword_argument_matching?

          deprecation_warning(parameter, @value) if Mocha::RUBY_V27_PLUS
        end

        true
      end

      def mocha_inspect
        @value.mocha_inspect
      end

      private

      def extract_parameter(available_parameters)
        [available_parameters.shift, available_parameters.empty?]
      end

      def same_type_of_hash?(actual, expected)
        ruby2_keywords_hash?(actual) == ruby2_keywords_hash?(expected)
      end

      def deprecation_warning(actual, expected)
        details = "Expected #{hash_type(expected)} (#{expected.mocha_inspect}), but received #{hash_type(actual)} (#{actual.mocha_inspect})."
        sentence1 = 'These will stop matching when strict keyword argument matching is enabled.'
        sentence2 = 'See the documentation for Mocha::Configuration#strict_keyword_argument_matching=.'
        Deprecation.warning([details, sentence1, sentence2].join(' '))
      end

      def hash_type(hash)
        ruby2_keywords_hash?(hash) ? 'keyword arguments' : 'positional hash'
      end

      def ruby2_keywords_hash?(hash)
        hash.is_a?(Hash) && ::Hash.ruby2_keywords_hash?(hash)
      end
    end
  end
end
