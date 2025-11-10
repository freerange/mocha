require File.expand_path('../../../test_helper', __FILE__)

require 'mocha/parameter_matchers/regexp_matches'
require 'mocha/inspect'
require 'parameter_matchers_test_helper'

class RegexpMatchesTest < Mocha::TestCase
  include Mocha::ParameterMatchers::Methods

  def test_should_match_parameter_matching_regular_expression
    matcher = regexp_matches(/oo/)
    assert matcher.matches?(['foo'])
  end

  def test_should_not_match_parameter_not_matching_regular_expression
    matcher = regexp_matches(/oo/)
    assert !matcher.matches?(['bar'])
  end

  def test_should_describe_matcher
    matcher = regexp_matches(/oo/)
    assert_equal 'regexp_matches(/oo/)', matcher.mocha_inspect
  end

  def test_should_not_raise_error_on_empty_arguments
    matcher = regexp_matches(/oo/)
    assert_nothing_raised { matcher.matches?([]) }
  end

  def test_should_not_match_on_empty_arguments
    matcher = regexp_matches(/oo/)
    assert !matcher.matches?([])
  end

  def test_should_not_raise_error_on_argument_that_does_not_respond_to_equals_tilde
    matcher = regexp_matches(/oo/)
    assert_nothing_raised { matcher.matches?([object_not_responding_to_equals_tilde]) }
  end

  def test_should_not_match_on_argument_that_does_not_respond_to_equals_tilde
    matcher = regexp_matches(/oo/)
    assert !matcher.matches?([object_not_responding_to_equals_tilde])
  end

  private

  def object_not_responding_to_equals_tilde
    Class.new { undef =~ if respond_to?(:=~) }.new
  end

  include ParameterMatchersTestHelper.deprecation_tests_for_matcher_method(:regexp_matches, /oo/)
end
