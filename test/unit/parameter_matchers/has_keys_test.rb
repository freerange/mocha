require File.expand_path('../../../test_helper', __FILE__)

require 'mocha/parameter_matchers/has_keys'
require 'mocha/parameter_matchers/instance_methods'
require 'mocha/inspect'

class HasKeysTest < Mocha::TestCase
  include Mocha::ParameterMatchers::Methods

  def test_should_match_hash_including_specified_keys
    matcher = has_keys(:key_1, :key_2)
    assert matcher.matches?([{ key_1: 1, key_2: 2, key_3: 3 }])
  end

  def test_should_not_match_hash_not_including_specified_keys
    matcher = has_keys(:key_1, :key_2)
    assert !matcher.matches?([{ key_3: 3 }])
  end

  def test_should_not_match_hash_not_including_all_keys
    matcher = has_keys(:key_1, :key_2)
    assert !matcher.matches?([{ key_1: 1, key_3: 3 }])
  end

  def test_should_describe_matcher
    matcher = has_keys(:key_1, :key_2)
    assert_equal 'has_keys(:key_1, :key_2)', matcher.mocha_inspect
  end

  def test_should_match_hash_including_specified_key_with_nested_key_matcher
    matcher = has_keys(equals(:key_1), equals(:key_2))
    assert matcher.matches?([{ key_1: 1, key_2: 2 }])
  end

  def test_should_not_match_hash_not_including_specified_keys_with_nested_key_matchers
    matcher = has_keys(equals(:key_1), equals(:key2))
    assert !matcher.matches?([{ key_2: 2 }])
  end

  def test_should_not_raise_error_on_empty_arguments
    matcher = has_keys(:key_1, :key_2)
    assert_nothing_raised { matcher.matches?([]) }
  end

  def test_should_not_match_on_empty_arguments
    matcher = has_keys(:key_1, :key_2)
    assert !matcher.matches?([])
  end

  def test_should_not_raise_error_on_argument_that_does_not_respond_to_keys
    matcher = has_keys(:key_1, :key_2)
    assert_nothing_raised { matcher.matches?([:key_1]) }
  end

  def test_should_not_match_on_argument_that_does_not_respond_to_keys
    matcher = has_keys(:key_1, :key_2)
    assert !matcher.matches?([:key_1])
  end

  def test_should_raise_argument_error_if_no_keys_are_supplied
    e = assert_raises(ArgumentError) { has_keys }
    assert_equal 'No arguments. Expecting at least one.', e.message
  end
end
