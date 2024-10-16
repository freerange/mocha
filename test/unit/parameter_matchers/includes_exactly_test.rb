require File.expand_path('../../../test_helper', __FILE__)

require 'mocha/parameter_matchers/includes_exactly'
require 'mocha/parameter_matchers/instance_methods'
require 'mocha/parameter_matchers/has_key'
require 'mocha/parameter_matchers/regexp_matches'
require 'mocha/inspect'

class IncludesExactlyTest < Mocha::TestCase
  include Mocha::ParameterMatchers

  def test_should_match_object_including_array_with_exact_values
    matcher = includes_exactly(:x, :y, :z)
    assert matcher.matches?([[:y, :z, :x]])
  end

  def test_should_not_match_object_that_does_not_include_value
    matcher = includes_exactly(:not_included)
    assert !matcher.matches?([[:x, :y, :z]])
  end

  def test_should_not_match_object_that_does_not_include_any_one_value
    matcher = includes_exactly(:x, :y, :z, :not_included)
    assert !matcher.matches?([[:x, :y, :z]])
  end

  def test_should_not_match_object_that_does_not_include_all_values
    matcher = includes_exactly(:x, :y)
    assert !matcher.matches?([[:x, :y, :z]])
  end

  def test_should_not_match_if_number_of_occurances_is_not_identical
    matcher = includes_exactly(:x, :y, :y)
    assert !matcher.matches?([[:x, :x, :y]])
  end

  def test_should_describe_matcher_with_one_item
    matcher = includes_exactly(:x)
    assert_equal 'includes_exactly(:x)', matcher.mocha_inspect
  end

  def test_should_describe_matcher_with_multiple_items
    matcher = includes_exactly(:x, :y, :z)
    assert_equal 'includes_exactly(:x, :y, :z)', matcher.mocha_inspect
  end

  def test_should_not_raise_error_on_emtpy_arguments
    matcher = includes_exactly(:x)
    assert_nothing_raised { matcher.matches?([]) }
  end

  def test_should_not_match_on_empty_arguments
    matcher = includes_exactly(:x)
    assert !matcher.matches?([])
  end

  def test_should_not_match_on_empty_array_arguments
    matcher = includes_exactly(:x)
    assert !matcher.matches?([[]])
  end

  def test_should_not_raise_error_on_argument_that_does_not_respond_to_include
    matcher = includes_exactly(:x)
    assert_nothing_raised { matcher.matches?([:x]) }
  end

  def test_should_not_match_on_argument_that_does_not_respond_to_include
    matcher = includes_exactly(:x)
    assert !matcher.matches?([:x])
  end

  def test_should_match_object_with_nested_matchers
    matcher = includes_exactly(has_key(:key1), :x)
    assert matcher.matches?([[:x, { key1: 'value' }]])
  end

  def test_should_not_match_object_with_an_unmatched_nested_matchers
    matcher = includes_exactly(has_key(:key1), :x)
    assert !matcher.matches?([[:x, { no_match: 'value' }]])
  end

  def test_should_not_match_string_argument_containing_substring
    matcher = includes_exactly('bar')
    assert !matcher.matches?(['foobarbaz'])
  end

  def test_should_match_exact_string_argument
    matcher = includes_exactly('bar')
    assert matcher.matches?(['bar'])
  end

  def test_should_match_hash_argument_containing_exact_keys
    matcher = includes_exactly(:key1, :key2)
    assert matcher.matches?([{ key2: 1, key1: 2 }])
  end

  def test_should_not_match_hash_argument_not_matching_all_keys
    matcher = includes_exactly(:key)
    assert !matcher.matches?([{ thing: 1, key: 2 }])
  end

  def test_should_match_hash_when_nested_matcher_matches_key
    matcher = includes_exactly(regexp_matches(/ar/), 'foo')
    assert matcher.matches?([{ 'foo' => 1, 'bar' => 2 }])
  end

  def test_should_not_match_hash_when_nested_matcher_doesn_not_match_key
    matcher = includes_exactly(regexp_matches(/az/), 'foo')
    assert !matcher.matches?([{ 'foo' => 1, 'bar' => 2 }])
  end
end
