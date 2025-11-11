require File.expand_path('../../../test_helper', __FILE__)

require 'mocha/parameter_matchers/anything'
require 'mocha/inspect'
require 'parameter_matchers_test_helper'

class AnythingTest < Mocha::TestCase
  include Mocha::ParameterMatchers::Methods

  def test_should_match_anything
    matcher = anything
    assert matcher.matches?([:something])
    assert matcher.matches?([{ 'x' => 'y' }])
  end

  def test_should_describe_matcher
    matcher = anything
    assert_equal 'anything', matcher.mocha_inspect
  end

  include ParameterMatchersTestHelper.deprecation_tests_for_matcher_method(:anything)
end
