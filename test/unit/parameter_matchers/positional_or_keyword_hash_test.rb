require File.expand_path('../../../test_helper', __FILE__)

require 'mocha/parameter_matchers/positional_or_keyword_hash'
require 'mocha/parameter_matchers/instance_methods'
require 'mocha/inspect'

class PositionalOrKeywordHashTest < Mocha::TestCase
  include Mocha::ParameterMatchers

  def test_should_describe_matcher
    matcher = { :key_1 => 1, :key_2 => 2 }.to_matcher
    assert_equal '{:key_1 => 1, :key_2 => 2}', matcher.mocha_inspect
  end

  def test_should_match_hash_arg_with_hash_arg
    matcher = { :key_1 => 1, :key_2 => 2 }.to_matcher
    assert matcher.matches?([{ :key_1 => 1, :key_2 => 2 }])
  end

  def test_should_match_non_last_hash_arg_with_hash_arg
    matcher = { :key_1 => 1, :key_2 => 2 }.to_matcher
    assert matcher.matches?([{ :key_1 => 1, :key_2 => 2 }, %w[a b]])
  end

  def test_should_not_match_non_hash_arg_with_hash_arg
    matcher = { :key_1 => 1, :key_2 => 2 }.to_matcher
    assert !matcher.matches?([%w[a b]])
  end

  if Mocha::RUBY_V27_PLUS
    def test_should_match_non_last_hash_arg_with_hash_arg_when_strict_keyword_args_is_enabled
      matcher = { :key_1 => 1, :key_2 => 2 }.to_matcher
      Mocha::Configuration.override(:strict_keyword_argument_matching => true) do
        assert matcher.matches?([{ :key_1 => 1, :key_2 => 2 }, %w[a b]])
      end
    end

    def test_should_not_match_non_hash_arg_with_hash_arg_when_strict_keyword_args_is_enabled
      matcher = { :key_1 => 1, :key_2 => 2 }.to_matcher
      Mocha::Configuration.override(:strict_keyword_argument_matching => true) do
        assert !matcher.matches?([%w[a b]])
      end
    end

    def test_should_match_hash_arg_with_hash_arg_when_strict_keyword_args_is_enabled
      matcher = { :key_1 => 1, :key_2 => 2 }.to_matcher
      Mocha::Configuration.override(:strict_keyword_argument_matching => true) do
        assert matcher.matches?([{ :key_1 => 1, :key_2 => 2 }])
      end
    end

    def test_should_match_keyword_args_with_keyword_args_when_strict_keyword_args_is_enabled
      matcher = Hash.ruby2_keywords_hash({ :key_1 => 1, :key_2 => 2 }).to_matcher # rubocop:disable Style/BracesAroundHashParameters
      Mocha::Configuration.override(:strict_keyword_argument_matching => true) do
        assert matcher.matches?([Hash.ruby2_keywords_hash({ :key_1 => 1, :key_2 => 2 })]) # rubocop:disable Style/BracesAroundHashParameters
      end
    end

    def test_should_not_match_hash_arg_with_keyword_args_when_strict_keyword_args_is_enabled
      matcher = Hash.ruby2_keywords_hash({ :key_1 => 1, :key_2 => 2 }).to_matcher # rubocop:disable Style/BracesAroundHashParameters
      Mocha::Configuration.override(:strict_keyword_argument_matching => true) do
        assert !matcher.matches?([{ :key_1 => 1, :key_2 => 2 }])
      end
    end

    def test_should_not_match_keyword_args_with_hash_arg_when_strict_keyword_args_is_enabled
      matcher = { :key_1 => 1, :key_2 => 2 }.to_matcher
      Mocha::Configuration.override(:strict_keyword_argument_matching => true) do
        assert !matcher.matches?([Hash.ruby2_keywords_hash({ :key_1 => 1, :key_2 => 2 })]) # rubocop:disable Style/BracesAroundHashParameters
      end
    end
  end
end
