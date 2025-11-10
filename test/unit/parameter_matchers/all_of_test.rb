require File.expand_path('../../../test_helper', __FILE__)

require 'mocha/parameter_matchers'
require 'mocha/inspect'
require 'stub_matcher'
require 'deprecation_disabler'

class AllOfTest < Mocha::TestCase
  include Mocha::ParameterMatchers

  def test_should_match_if_all_matchers_match
    matcher = all_of(Stub::Matcher.new(true), Stub::Matcher.new(true), Stub::Matcher.new(true))
    assert matcher.matches?(['any_old_value'])
  end

  def test_should_not_match_if_any_matcher_does_not_match
    matcher = all_of(Stub::Matcher.new(true), Stub::Matcher.new(false), Stub::Matcher.new(true))
    assert !matcher.matches?(['any_old_value'])
  end

  def test_should_describe_matcher
    matcher = all_of(Stub::Matcher.new(true), Stub::Matcher.new(false), Stub::Matcher.new(true))
    assert_equal 'all_of(matcher(true), matcher(false), matcher(true))', matcher.mocha_inspect
  end

  def test_should_deprecate_referencing_matcher_class_from_test_class
    DeprecationDisabler.disable_deprecations do
      AllOf
    end
    assert_equal(
      'AllOf is deprecated. Use Mocha::ParameterMatchers::AllOf instead.',
      Mocha::Deprecation.messages.last
    )
  end

  def test_should_allow_referencing_fully_qualified_matcher_class_from_test_class
    DeprecationDisabler.disable_deprecations do
      Mocha::ParameterMatchers::AllOf
    end
    assert Mocha::Deprecation.messages.empty?
  end
end
