require File.expand_path('../../../test_helper', __FILE__)

require 'mocha/parameter_matchers/equals'
require 'mocha/inspect'
require 'parameter_matchers_test_helper'

class EqualsTest < Mocha::TestCase
  include Mocha::ParameterMatchers::Methods

  def test_should_match_object_that_equals_value
    matcher = equals('x')
    assert matcher.matches?(['x'])
  end

  def test_should_not_match_object_that_does_not_equal_value
    matcher = equals('x')
    assert !matcher.matches?(['y'])
  end

  def test_should_describe_matcher
    matcher = equals('x')
    assert_equal %("x"), matcher.mocha_inspect
  end

  include ParameterMatchersTestHelper.deprecation_tests_for_matcher_method(:equals, :dummy_value)
end
