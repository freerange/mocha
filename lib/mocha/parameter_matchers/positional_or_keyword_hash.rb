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
      include Base

      def self.for(expected_value, expectation)
        (Hash.ruby2_keywords_hash?(expected_value) ? KeywordsHash : PositionalHash).new(expected_value, expectation)
      end

      def initialize(expected_value, expectation)
        @expected_value = expected_value
        @expectation = expectation
      end

      def matches?(actual_values)
        actual_value = actual_values.shift
        matches_entries_exactly?(actual_value) && (actual_values.any? || matches_last_actual_value?(actual_value))
      end

      def mocha_inspect
        @expected_value.mocha_inspect
      end

      private

      def matches_entries_exactly?(actual_value)
        HasEntries.new(@expected_value, exact: true).matches?([actual_value])
      end
    end

    class KeywordsHash < PositionalOrKeywordHash
      def matches_last_actual_value?(actual_value)
        if actual_value.is_a?(Hash) && Hash.ruby2_keywords_hash?(actual_value)
          true
        elsif Mocha.configuration.strict_keyword_argument_matching?
          false
        else
          deprecation_warning(actual_value, @expected_value) if Mocha::RUBY_V27_PLUS
          true
        end
      end

      def deprecation_warning(actual, expected)
        expectation_definition = @expectation ? "defined at #{@expectation.definition_location}" : ''
        details1 = "Expectation #{expectation_definition} expected keyword arguments (#{expected.mocha_inspect}),".squeeze(' ')
        details2 = "but received positional hash (#{actual.mocha_inspect})."
        sentence1 = 'These will stop matching when strict keyword argument matching is enabled.'
        sentence2 = 'See the documentation for Mocha::Configuration#strict_keyword_argument_matching=.'
        Deprecation.warning([details1, details2, sentence1, sentence2].join(' '))
      end
    end

    class PositionalHash < PositionalOrKeywordHash
      def matches_last_actual_value?(actual_value)
        true
      end
    end
  end
end
