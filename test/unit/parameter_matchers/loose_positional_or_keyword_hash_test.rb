# frozen_string_literal: true

require File.expand_path('../../../test_helper', __FILE__)

require 'mocha/parameter_matchers/positional_or_keyword_hash'
require 'mocha/parameter_matchers/instance_methods'
require 'mocha/inspect'
require 'mocha/expectation'
require 'mocha/ruby_version'
require 'mocha/configuration'
require 'fake_logger'

class LoosePositionalOrKeywordHashTest < Mocha::TestCase
  include Mocha::ParameterMatchers::Methods
  include FakeLogger::TestHelper

  def setup
    return unless Mocha::RUBY_V27_PLUS

    @original = Mocha.configuration.strict_keyword_argument_matching?
    Mocha.configure { |c| c.strict_keyword_argument_matching = false }

    FakeLogger::TestHelper.setup
  end

  def teardown
    return unless Mocha::RUBY_V27_PLUS

    FakeLogger::TestHelper.teardown

    Mocha.configure { |c| c.strict_keyword_argument_matching = @original }
  end

  def test_should_match_hash_arg_with_keyword_args_but_display_deprecation_warning_if_not_last_matcher
    expectation = Mocha::Expectation.new(self, :foo)
    last_matcher = false
    matcher = build_matcher(Hash.ruby2_keywords_hash({ key_1: 1, key_2: 2 }), expectation, last_matcher)
    assert matcher.matches?([{ key_1: 1, key_2: 2 }])
    return unless Mocha::RUBY_V27_PLUS

    message = logger.warnings.last
    location = expectation.definition_location
    assert_includes message, "Expectation defined at #{location} expected keyword arguments (key_1: 1, key_2: 2)"
    assert_includes message, 'but received positional hash ({key_1: 1, key_2: 2})'
    assert_includes message, 'These will stop matching when strict keyword argument matching is enabled.'
    assert_includes message, 'See the documentation for Mocha::Configuration#strict_keyword_argument_matching=.'
  end

  def test_should_match_hash_arg_with_keyword_args_but_display_deprecation_warning_if_last_matcher
    expectation = Mocha::Expectation.new(self, :foo)
    last_matcher = true
    matcher = build_matcher(Hash.ruby2_keywords_hash({ key_1: 1, key_2: 2 }), expectation, last_matcher)
    assert matcher.matches?([{ key_1: 1, key_2: 2 }])
    return unless Mocha::RUBY_V27_PLUS

    message = logger.warnings.last
    location = expectation.definition_location
    assert_includes message, "Expectation defined at #{location} expected keyword arguments (key_1: 1, key_2: 2)"
    assert_includes message, 'but received positional hash ({key_1: 1, key_2: 2})'
    assert_includes message, 'These will stop matching when strict keyword argument matching is enabled.'
    assert_includes message, 'See the documentation for Mocha::Configuration#strict_keyword_argument_matching=.'
  end

  def test_should_match_keyword_args_with_hash_arg_but_display_deprecation_warning_if_not_last_matcher
    expectation = Mocha::Expectation.new(self, :foo)
    last_matcher = false
    matcher = build_matcher({ key_1: 1, key_2: 2 }, expectation, last_matcher)
    assert matcher.matches?([Hash.ruby2_keywords_hash({ key_1: 1, key_2: 2 })])
    return unless Mocha::RUBY_V27_PLUS

    message = logger.warnings.last
    location = expectation.definition_location
    assert_includes message, "Expectation defined at #{location} expected positional hash ({key_1: 1, key_2: 2})"
    assert_includes message, 'but received keyword arguments (key_1: 1, key_2: 2)'
    assert_includes message, 'These will stop matching when strict keyword argument matching is enabled.'
    assert_includes message, 'See the documentation for Mocha::Configuration#strict_keyword_argument_matching=.'
  end

  def test_should_match_keyword_args_with_hash_arg_but_not_display_deprecation_warning_if_last_matcher
    expectation = Mocha::Expectation.new(self, :foo)
    last_matcher = true
    matcher = build_matcher({ key_1: 1, key_2: 2 }, expectation, last_matcher)
    assert matcher.matches?([Hash.ruby2_keywords_hash({ key_1: 1, key_2: 2 })])
    return unless Mocha::RUBY_V27_PLUS

    assert_nil logger.warnings.last
  end

  def test_should_display_deprecation_warning_even_if_parent_expectation_is_nil
    expectation = nil
    matcher = build_matcher({ key_1: 1, key_2: 2 }, expectation)
    matcher.matches?([Hash.ruby2_keywords_hash({ key_1: 1, key_2: 2 })])
    return unless Mocha::RUBY_V27_PLUS

    message = logger.warnings.last
    assert_includes message, 'Expectation expected positional hash ({key_1: 1, key_2: 2})'
    assert_includes message, 'but received keyword arguments (key_1: 1, key_2: 2)'
  end

  private

  def build_matcher(hash, expectation = nil, last = nil)
    Mocha::ParameterMatchers::PositionalOrKeywordHash.new(hash, expectation, last)
  end
end
