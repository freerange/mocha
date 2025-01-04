# frozen_string_literal: true

require 'mocha/configuration'
require 'mocha/deprecation'
require 'mocha/ruby_version'
require 'mocha/parameter_matchers/base'
require 'mocha/parameter_matchers/has_entries'

module Mocha
  module ParameterMatchers
    # @private
    class PositionalOrKeywordHash
      include BaseMethods

      def initialize(expected_value, expectation)
        @expected_value = expected_value
        @expectation = expectation
      end

      def matches?(actual_values)
        parameter, is_last_parameter = extract_parameter(actual_values)

        return false unless HasEntries.new(@expected_value, exact: true).matches?([parameter])

        if is_last_parameter && !same_type_of_hash?(parameter, @expected_value)
          return false if Mocha.configuration.strict_keyword_argument_matching?

          deprecation_warning(parameter, @expected_value) if Mocha::RUBY_V27_PLUS
        end

        true
      end

      def mocha_inspect
        @expected_value.mocha_inspect
      end

      private

      def extract_parameter(actual_values)
        [actual_values.shift, actual_values.empty?]
      end

      def same_type_of_hash?(actual, expected)
        ruby2_keywords_hash?(actual) == ruby2_keywords_hash?(expected)
      end

      def deprecation_warning(actual, expected)
        details1 = "Expectation #{expectation_definition} expected #{hash_type(expected)} (#{expected.mocha_inspect}),".squeeze(' ')
        details2 = "but received #{hash_type(actual)} (#{actual.mocha_inspect})."
        sentence1 = 'These will stop matching when strict keyword argument matching is enabled.'
        sentence2 = 'See the documentation for Mocha::Configuration#strict_keyword_argument_matching=.'
        Deprecation.warning([details1, details2, sentence1, sentence2].join(' '))
      end

      def hash_type(hash)
        ruby2_keywords_hash?(hash) ? 'keyword arguments' : 'positional hash'
      end

      def ruby2_keywords_hash?(hash)
        hash.is_a?(Hash) && ::Hash.ruby2_keywords_hash?(hash)
      end

      def expectation_definition
        return nil unless @expectation

        "defined at #{@expectation.definition_location}"
      end
    end
  end
end
