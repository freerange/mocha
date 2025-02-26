# frozen_string_literal: true

require File.expand_path('../../../test_helper', __FILE__)

require 'mocha/parameter_matchers/positional_or_keyword_hash'
require 'mocha/parameter_matchers/instance_methods'
require 'mocha/inspect'
require 'mocha/expectation'
require 'mocha/ruby_version'

class PositionalOrKeywordHashTest < Mocha::TestCase
  include Mocha::ParameterMatchers

  def test_should_describe_matcher
    matcher = build_matcher({ key_1: 1, key_2: 2 })
    assert_equal '{key_1: 1, key_2: 2}', matcher.mocha_inspect
  end

  def test_should_not_match_non_hash_arg_with_hash_arg
    matcher = build_matcher({ key_1: 1, key_2: 2 })
    assert !matcher.matches?([%w[a b]])
  end

  def test_should_match_hash_arg_with_hash_arg
    matcher = build_matcher({ key_1: 1, key_2: 2 })
    assert matcher.matches?([{ key_1: 1, key_2: 2 }])
  end

  def test_should_not_match_hash_arg_with_different_hash_arg
    matcher = build_matcher({ key_1: 1 })
    assert !matcher.matches?([{ key_1: 1, key_2: 2 }])
  end

  def test_should_match_keyword_args_with_keyword_args
    matcher = build_matcher(Hash.ruby2_keywords_hash({ key_1: 1, key_2: 2 }))
    assert matcher.matches?([Hash.ruby2_keywords_hash({ key_1: 1, key_2: 2 })])
  end

  def test_should_not_match_keyword_args_with_different_keyword_args
    matcher = build_matcher(Hash.ruby2_keywords_hash({ key_1: 1 }))
    assert !matcher.matches?([Hash.ruby2_keywords_hash({ key_1: 1, key_2: 2 })])
  end

  def test_should_match_keyword_args_with_matchers_using_keyword_args
    matcher = build_matcher(Hash.ruby2_keywords_hash({ key_1: is_a(String), key_2: is_a(Integer) }))
    assert matcher.matches?([Hash.ruby2_keywords_hash({ key_1: 'foo', key_2: 2 })])
  end

  def test_should_not_match_keyword_args_with_matchers_using_keyword_args_when_not_all_entries_are_matched
    matcher = build_matcher(Hash.ruby2_keywords_hash({ key_1: is_a(String) }))
    assert !matcher.matches?([Hash.ruby2_keywords_hash({ key_1: 'foo', key_2: 2 })])
  end

  private

  def build_matcher(hash)
    Mocha::ParameterMatchers::PositionalOrKeywordHash.for(hash, nil)
  end
end
