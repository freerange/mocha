# frozen_string_literal: true

require File.expand_path('../../../test_helper', __FILE__)

require 'mocha/parameter_matchers/positional_or_keyword_hash'
require 'mocha/parameter_matchers/instance_methods'
require 'mocha/inspect'
require 'mocha/expectation'
require 'mocha/ruby_version'
require 'mocha/configuration'

class StrictPositionalOrKeywordHashTest < Mocha::TestCase
  include Mocha::ParameterMatchers

  def setup
    return unless Mocha::RUBY_V27_PLUS

    @original = Mocha.configuration.strict_keyword_argument_matching?
    Mocha.configure { |c| c.strict_keyword_argument_matching = true }
  end

  def teardown
    return unless Mocha::RUBY_V27_PLUS

    Mocha.configure { |c| c.strict_keyword_argument_matching = @original } if Mocha::RUBY_V27_PLUS
  end

  if Mocha::RUBY_V27_PLUS
    def test_should_match_non_last_hash_arg_with_hash_arg
      hash = { key_1: 1, key_2: 2 }
      matcher = build_matcher(hash)
      assert matcher.matches?([{ key_1: 1, key_2: 2 }, %w[a b]])
    end

    def test_should_not_match_non_hash_arg_with_hash_arg
      hash = { key_1: 1, key_2: 2 }
      matcher = build_matcher(hash)
      assert !matcher.matches?([%w[a b]])
    end

    def test_should_match_hash_arg_with_hash_arg
      hash = { key_1: 1, key_2: 2 }
      matcher = build_matcher(hash)
      assert matcher.matches?([{ key_1: 1, key_2: 2 }])
    end

    def test_should_match_keyword_args_with_keyword_args
      matcher = build_matcher(Hash.ruby2_keywords_hash({ key_1: 1, key_2: 2 }))
      assert matcher.matches?([Hash.ruby2_keywords_hash({ key_1: 1, key_2: 2 })])
    end

    def test_should_not_match_hash_arg_with_keyword_args_if_not_last_matcher
      last_matcher = false
      matcher = build_matcher(Hash.ruby2_keywords_hash({ key_1: 1, key_2: 2 }), nil, last_matcher)
      assert !matcher.matches?([{ key_1: 1, key_2: 2 }])
    end

    def test_should_not_match_hash_arg_with_keyword_args_if_last_matcher
      last_matcher = true
      matcher = build_matcher(Hash.ruby2_keywords_hash({ key_1: 1, key_2: 2 }), nil, last_matcher)
      assert !matcher.matches?([{ key_1: 1, key_2: 2 }])
    end

    def test_should_not_match_keyword_args_with_hash_arg_if_not_last_matcher
      hash = { key_1: 1, key_2: 2 }
      last_matcher = false
      matcher = build_matcher(hash, nil, last_matcher)
      assert !matcher.matches?([Hash.ruby2_keywords_hash({ key_1: 1, key_2: 2 })])
    end

    def test_should_match_keyword_args_with_hash_arg_if_last_matcher
      hash = { key_1: 1, key_2: 2 }
      last_matcher = true
      matcher = build_matcher(hash, nil, last_matcher)
      assert matcher.matches?([Hash.ruby2_keywords_hash({ key_1: 1, key_2: 2 })])
    end
  end

  private

  def build_matcher(hash, expectation = nil, last = nil)
    Mocha::ParameterMatchers::PositionalOrKeywordHash.new(hash, expectation, last)
  end
end
