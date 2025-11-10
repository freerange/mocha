require File.expand_path('../../../test_helper', __FILE__)

require 'mocha/parameter_matchers/instance_of'
require 'mocha/inspect'
require 'parameter_matchers_test_helper'

class InstanceOfTest < Mocha::TestCase
  include Mocha::ParameterMatchers::Methods

  def test_should_match_object_that_is_an_instance_of_specified_class
    matcher = instance_of(String)
    assert matcher.matches?(['string'])
  end

  def test_should_not_match_object_that_is_not_an_instance_of_specified_class
    matcher = instance_of(String)
    assert !matcher.matches?([99])
  end

  def test_should_describe_matcher
    matcher = instance_of(String)
    assert_equal 'instance_of(String)', matcher.mocha_inspect
  end

  include ParameterMatchersTestHelper.deprecation_tests_for_matcher_method(:instance_of, String)
  include ParameterMatchersTestHelper.deprecation_tests_for_matcher_class(:InstanceOf)
end
