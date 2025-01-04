# frozen_string_literal: true

require File.expand_path('../../../test_helper', __FILE__)

require 'mocha/parameter_matchers/positional_or_keyword_hash'
require 'mocha/parameter_matchers/instance_methods'
require 'mocha/inspect'
require 'mocha/expectation'
require 'mocha/ruby_version'

class StrictPositionalOrKeywordHashTest < Mocha::TestCase
  include Mocha::ParameterMatchers

  if Mocha::RUBY_V27_PLUS
    def test_should_match_non_last_hash_arg_with_hash_arg_when_strict_keyword_args_is_enabled
      hash = { key_1: 1, key_2: 2 }
      matcher = build_matcher(hash)
      Mocha::Configuration.override(strict_keyword_argument_matching: true) do
        assert matcher.matches?([{ key_1: 1, key_2: 2 }, %w[a b]])
      end
    end

    def test_should_not_match_non_hash_arg_with_hash_arg_when_strict_keyword_args_is_enabled
      hash = { key_1: 1, key_2: 2 }
      matcher = build_matcher(hash)
      Mocha::Configuration.override(strict_keyword_argument_matching: true) do
        assert !matcher.matches?([%w[a b]])
      end
    end

    def test_should_match_hash_arg_with_hash_arg_when_strict_keyword_args_is_enabled
      hash = { key_1: 1, key_2: 2 }
      matcher = build_matcher(hash)
      Mocha::Configuration.override(strict_keyword_argument_matching: true) do
        assert matcher.matches?([{ key_1: 1, key_2: 2 }])
      end
    end

    def test_should_match_keyword_args_with_keyword_args_when_strict_keyword_args_is_enabled
      matcher = build_matcher(Hash.ruby2_keywords_hash({ key_1: 1, key_2: 2 }))
      Mocha::Configuration.override(strict_keyword_argument_matching: true) do
        assert matcher.matches?([Hash.ruby2_keywords_hash({ key_1: 1, key_2: 2 })])
      end
    end

    def test_should_not_match_hash_arg_with_keyword_args_when_strict_keyword_args_is_enabled
      matcher = build_matcher(Hash.ruby2_keywords_hash({ key_1: 1, key_2: 2 }))
      Mocha::Configuration.override(strict_keyword_argument_matching: true) do
        assert !matcher.matches?([{ key_1: 1, key_2: 2 }])
      end
    end

    def test_should_not_match_keyword_args_with_hash_arg_when_strict_keyword_args_is_enabled
      hash = { key_1: 1, key_2: 2 }
      matcher = build_matcher(hash)
      Mocha::Configuration.override(strict_keyword_argument_matching: true) do
        assert !matcher.matches?([Hash.ruby2_keywords_hash({ key_1: 1, key_2: 2 })])
      end
    end
  end

  private

  def build_matcher(hash, expectation = nil)
    Mocha::ParameterMatchers::PositionalOrKeywordHash.new(hash, expectation)
  end
end
