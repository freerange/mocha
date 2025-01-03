# frozen_string_literal: true

require File.expand_path('../../../test_helper', __FILE__)

require 'mocha/parameter_matchers/not'
require 'mocha/inspect'
require 'parameter_matchers/stub_matcher'

class NotTest < Mocha::TestCase
  include Mocha::ParameterMatchers::Methods

  def test_should_match_if_matcher_does_not_match
    matcher = Not(StubMatcher.new(false))
    assert matcher.matches?(['any_old_value'])
  end

  def test_should_not_match_if_matcher_does_match
    matcher = Not(StubMatcher.new(true))
    assert !matcher.matches?(['any_old_value'])
  end

  def test_should_describe_matcher
    matcher = Not(StubMatcher.new(true))
    assert_equal 'Not(matcher(true))', matcher.mocha_inspect
  end
end
