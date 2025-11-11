require File.expand_path('../../../test_helper', __FILE__)

require 'mocha/parameter_matchers/any_of'
require 'mocha/inspect'
require 'stub_matcher'
require 'parameter_matchers_test_helper'

class AnyOfTest < Mocha::TestCase
  include Mocha::ParameterMatchers::Methods

  def test_should_match_if_any_matchers_match
    matcher = any_of(Stub::Matcher.new(false), Stub::Matcher.new(true), Stub::Matcher.new(false))
    assert matcher.matches?(['any_old_value'])
  end

  def test_should_not_match_if_no_matchers_match
    matcher = any_of(Stub::Matcher.new(false), Stub::Matcher.new(false), Stub::Matcher.new(false))
    assert !matcher.matches?(['any_old_value'])
  end

  def test_should_describe_matcher
    matcher = any_of(Stub::Matcher.new(false), Stub::Matcher.new(true), Stub::Matcher.new(false))
    assert_equal 'any_of(matcher(false), matcher(true), matcher(false))', matcher.mocha_inspect
  end

  include ParameterMatchersTestHelper.deprecation_tests_for_matcher_method(:any_of)
  include ParameterMatchersTestHelper.deprecation_tests_for_matcher_class(:AnyOf)
end
