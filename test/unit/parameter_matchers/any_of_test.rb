# frozen_string_literal: true

require File.expand_path('../../../test_helper', __FILE__)

require 'mocha/parameter_matchers/any_of'
require 'mocha/inspect'
require 'parameter_matchers/stub_matcher'

class AnyOfTest < Mocha::TestCase
  include Mocha::ParameterMatchers

  def test_should_match_if_any_matchers_match
    matcher = any_of(StubMatcher.new(false), StubMatcher.new(true), StubMatcher.new(false))
    assert matcher.matches?(['any_old_value'])
  end

  def test_should_not_match_if_no_matchers_match
    matcher = any_of(StubMatcher.new(false), StubMatcher.new(false), StubMatcher.new(false))
    assert !matcher.matches?(['any_old_value'])
  end

  def test_should_describe_matcher
    matcher = any_of(StubMatcher.new(false), StubMatcher.new(true), StubMatcher.new(false))
    assert_equal 'any_of(matcher(false), matcher(true), matcher(false))', matcher.mocha_inspect
  end
end
