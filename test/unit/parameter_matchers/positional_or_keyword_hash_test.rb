require File.expand_path('../../../test_helper', __FILE__)

require 'deprecation_disabler'
require 'execution_point'
require 'mocha/parameter_matchers/positional_or_keyword_hash'
require 'mocha/parameter_matchers/instance_methods'
require 'mocha/inspect'
require 'mocha/expectation'

class PositionalOrKeywordHashTest < Mocha::TestCase
  include Mocha::ParameterMatchers

  def test_should_describe_matcher
    matcher = { key_1: 1, key_2: 2 }.to_matcher
    assert_equal '{:key_1 => 1, :key_2 => 2}', matcher.mocha_inspect
  end

  def test_should_match_non_last_hash_arg_with_hash_arg
    matcher = { key_1: 1, key_2: 2 }.to_matcher
    assert matcher.matches?([{ key_1: 1, key_2: 2 }, %w[a b]])
  end

  def test_should_not_match_non_hash_arg_with_hash_arg
    matcher = { key_1: 1, key_2: 2 }.to_matcher
    assert !matcher.matches?([%w[a b]])
  end

  def test_should_match_hash_arg_with_hash_arg
    matcher = { key_1: 1, key_2: 2 }.to_matcher
    assert matcher.matches?([{ key_1: 1, key_2: 2 }])
  end

  def test_should_match_keyword_args_with_keyword_args
    matcher = Hash.ruby2_keywords_hash({ key_1: 1, key_2: 2 }).to_matcher # rubocop:disable Style/BracesAroundHashParameters
    assert matcher.matches?([Hash.ruby2_keywords_hash({ key_1: 1, key_2: 2 })]) # rubocop:disable Style/BracesAroundHashParameters
  end

  def test_should_match_keyword_args_with_matchers_using_keyword_args
    matcher = Hash.ruby2_keywords_hash({ key_1: is_a(String), key_2: is_a(Integer) }).to_matcher # rubocop:disable Style/BracesAroundHashParameters
    assert matcher.matches?([Hash.ruby2_keywords_hash({ key_1: 'foo', key_2: 2 })]) # rubocop:disable Style/BracesAroundHashParameters
  end

  def test_should_match_hash_arg_with_keyword_args_but_display_deprecation_warning_if_appropriate
    expectation = Mocha::Expectation.new(self, :foo); execution_point = ExecutionPoint.current
    matcher = Hash.ruby2_keywords_hash({ key_1: 1, key_2: 2 }).to_matcher(expectation) # rubocop:disable Style/BracesAroundHashParameters
    DeprecationDisabler.disable_deprecations do
      assert matcher.matches?([{ key_1: 1, key_2: 2 }])
    end
    return unless Mocha::RUBY_V27_PLUS

    message = Mocha::Deprecation.messages.last
    location = "#{execution_point.file_name}:#{execution_point.line_number}:in `new'"
    assert_includes message, "Expectation defined at #{location} expected keyword arguments (:key_1 => 1, :key_2 => 2)"
    assert_includes message, 'but received positional hash ({:key_1 => 1, :key_2 => 2})'
    assert_includes message, 'These will stop matching when strict keyword argument matching is enabled.'
    assert_includes message, 'See the documentation for Mocha::Configuration#strict_keyword_argument_matching=.'
  end

  def test_should_match_keyword_args_with_hash_arg_but_display_deprecation_warning_if_appropriate
    expectation = Mocha::Expectation.new(self, :foo); execution_point = ExecutionPoint.current
    matcher = { key_1: 1, key_2: 2 }.to_matcher(expectation)
    DeprecationDisabler.disable_deprecations do
      assert matcher.matches?([Hash.ruby2_keywords_hash({ key_1: 1, key_2: 2 })]) # rubocop:disable Style/BracesAroundHashParameters
    end
    return unless Mocha::RUBY_V27_PLUS

    message = Mocha::Deprecation.messages.last
    location = "#{execution_point.file_name}:#{execution_point.line_number}:in `new'"
    assert_includes message, "Expectation defined at #{location} expected positional hash ({:key_1 => 1, :key_2 => 2})"
    assert_includes message, 'but received keyword arguments (:key_1 => 1, :key_2 => 2)'
    assert_includes message, 'These will stop matching when strict keyword argument matching is enabled.'
    assert_includes message, 'See the documentation for Mocha::Configuration#strict_keyword_argument_matching=.'
  end

  if Mocha::RUBY_V27_PLUS
    def test_should_match_non_last_hash_arg_with_hash_arg_when_strict_keyword_args_is_enabled
      matcher = { key_1: 1, key_2: 2 }.to_matcher
      Mocha::Configuration.override(strict_keyword_argument_matching: true) do
        assert matcher.matches?([{ key_1: 1, key_2: 2 }, %w[a b]])
      end
    end

    def test_should_not_match_non_hash_arg_with_hash_arg_when_strict_keyword_args_is_enabled
      matcher = { key_1: 1, key_2: 2 }.to_matcher
      Mocha::Configuration.override(strict_keyword_argument_matching: true) do
        assert !matcher.matches?([%w[a b]])
      end
    end

    def test_should_match_hash_arg_with_hash_arg_when_strict_keyword_args_is_enabled
      matcher = { key_1: 1, key_2: 2 }.to_matcher
      Mocha::Configuration.override(strict_keyword_argument_matching: true) do
        assert matcher.matches?([{ key_1: 1, key_2: 2 }])
      end
    end

    def test_should_match_keyword_args_with_keyword_args_when_strict_keyword_args_is_enabled
      matcher = Hash.ruby2_keywords_hash({ key_1: 1, key_2: 2 }).to_matcher # rubocop:disable Style/BracesAroundHashParameters
      Mocha::Configuration.override(strict_keyword_argument_matching: true) do
        assert matcher.matches?([Hash.ruby2_keywords_hash({ key_1: 1, key_2: 2 })]) # rubocop:disable Style/BracesAroundHashParameters
      end
    end

    def test_should_not_match_hash_arg_with_keyword_args_when_strict_keyword_args_is_enabled
      matcher = Hash.ruby2_keywords_hash({ key_1: 1, key_2: 2 }).to_matcher # rubocop:disable Style/BracesAroundHashParameters
      Mocha::Configuration.override(strict_keyword_argument_matching: true) do
        assert !matcher.matches?([{ key_1: 1, key_2: 2 }])
      end
    end

    def test_should_not_match_keyword_args_with_hash_arg_when_strict_keyword_args_is_enabled
      matcher = { key_1: 1, key_2: 2 }.to_matcher
      Mocha::Configuration.override(strict_keyword_argument_matching: true) do
        assert !matcher.matches?([Hash.ruby2_keywords_hash({ key_1: 1, key_2: 2 })]) # rubocop:disable Style/BracesAroundHashParameters
      end
    end

    def test_should_display_deprecation_warning_even_if_parent_expectation_is_nil
      expectation = nil
      matcher = { key_1: 1, key_2: 2 }.to_matcher(expectation)
      DeprecationDisabler.disable_deprecations do
        matcher.matches?([Hash.ruby2_keywords_hash({ key_1: 1, key_2: 2 })]) # rubocop:disable Style/BracesAroundHashParameters
      end

      message = Mocha::Deprecation.messages.last
      assert_includes message, 'Expectation expected positional hash ({:key_1 => 1, :key_2 => 2})'
      assert_includes message, 'but received keyword arguments (:key_1 => 1, :key_2 => 2)'
    end
  end
end
