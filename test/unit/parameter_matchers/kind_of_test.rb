require File.expand_path('../../../test_helper', __FILE__)

require 'mocha/parameter_matchers/kind_of'
require 'mocha/inspect'
require 'parameter_matchers_test_helper'

class KindOfTest < Mocha::TestCase
  include Mocha::ParameterMatchers::Methods

  def test_should_match_object_that_is_a_kind_of_specified_class
    matcher = kind_of(Integer)
    assert matcher.matches?([99])
  end

  def test_should_not_match_object_that_is_not_a_kind_of_specified_class
    matcher = kind_of(Integer)
    assert !matcher.matches?(['string'])
  end

  def test_should_describe_matcher
    matcher = kind_of(Integer)
    assert_equal 'kind_of(Integer)', matcher.mocha_inspect
  end

  include ParameterMatchersTestHelper.deprecation_tests_for_matcher_method(:kind_of, Integer)
end
