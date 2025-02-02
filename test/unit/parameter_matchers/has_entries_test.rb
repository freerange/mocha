# frozen_string_literal: true

require File.expand_path('../../../test_helper', __FILE__)

require 'mocha/parameter_matchers/has_entries'
require 'mocha/parameter_matchers/instance_methods'
require 'mocha/inspect'
require 'hashlike'

class HasEntriesTest < Mocha::TestCase
  include Mocha::ParameterMatchers

  def test_should_match_hash_including_specified_entries
    matcher = has_entries(key_1: 'value_1', key_2: 'value_2')
    assert matcher.matches?([{ key_1: 'value_1', key_2: 'value_2', key_3: 'value_3' }])
  end

  def test_should_not_match_hash_not_including_specified_entries
    matcher = has_entries(key_1: 'value_2', key_2: 'value_2', key_3: 'value_3')
    assert !matcher.matches?([{ key_1: 'value_1', key_2: 'value_2' }])
  end

  def test_should_match_hash_with_the_exact_specified_entries
    matcher = HasEntries.new({ key_1: 'value_1', key_2: 'value_2' }, exact: true)
    assert matcher.matches?([{ key_1: 'value_1', key_2: 'value_2' }])
  end

  def test_should_not_match_hash_with_the_exact_specified_entries
    matcher = HasEntries.new({ key_1: 'value_1', key_2: 'value_2' }, exact: true)
    assert !matcher.matches?([{ key_1: 'value_1', key_2: 'value_2', key_3: 'value_3' }])
  end

  def test_should_not_match_no_arguments_when_exact_match_not_required
    matcher = has_entries(key_1: 'value_1')
    assert !matcher.matches?([nil])
  end

  def test_should_not_match_no_arguments_when_exact_match_required
    matcher = HasEntries.new({ key_1: 'value_1' }, exact: true)
    assert !matcher.matches?([nil])
  end

  def test_should_match_hashlike_object
    matcher = has_entries(key_1: 'value_1')
    hashlike = Hashlike.new(key_1: 'value_1', key_2: 'value_2')
    assert matcher.matches?([hashlike])
  end

  def test_should_not_match_hashlike_object
    matcher = has_entries(key_1: 'value_1')
    hashlike = Hashlike.new({})
    assert !matcher.matches?([hashlike])
  end

  def test_should_match_hashlike_object_with_no_length_method_when_exact_match_required
    matcher = HasEntries.new({ key_1: 'value_1' }, exact: true)
    hashlike = Hashlike.new(key_1: 'value_1')
    assert matcher.matches?([hashlike])
  end

  def test_should_not_match_hashlike_object_with_no_length_method_when_exact_match_required
    matcher = HasEntries.new({ key_1: 'value_1' }, exact: true)
    hashlike = Hashlike.new(key_1: 'value_1', key_2: 'value_2')
    assert !matcher.matches?([hashlike])
  end

  def test_should_describe_matcher
    matcher = has_entries(key_1: 'value_1', key_2: 'value_2')
    description = matcher.mocha_inspect
    matches = /has_entries\((.*)\)/.match(description)
    assert_not_nil matches[0]
    # rubocop:disable Security/Eval
    entries = eval(matches[1], binding, __FILE__, __LINE__)
    # rubocop:enable Security/Eval
    assert_equal 'value_1', entries[:key_1]
    assert_equal 'value_2', entries[:key_2]
  end

  def test_should_match_hash_including_specified_entries_with_nested_key_matchers
    matcher = has_entries(equals(:key_1) => 'value_1', equals(:key_2) => 'value_2')
    assert matcher.matches?([{ key_1: 'value_1', key_2: 'value_2', key_3: 'value_3' }])
  end

  def test_should_not_match_hash_not_including_specified_entries_with_nested_key_matchers
    matcher = has_entries(equals(:key_1) => 'value_2', equals(:key_2) => 'value_2', equals(:key_3) => 'value_3')
    assert !matcher.matches?([{ key_1: 'value_1', key_2: 'value_2' }])
  end

  def test_should_match_hash_including_specified_entries_with_nested_value_matchers
    matcher = has_entries(key_1: equals('value_1'), key_2: equals('value_2'))
    assert matcher.matches?([{ key_1: 'value_1', key_2: 'value_2', key_3: 'value_3' }])
  end

  def test_should_not_match_hash_not_including_specified_entries_with_nested_value_matchers
    matcher = has_entries(key_1: equals('value_2'), key_2: equals('value_2'), key_3: equals('value_3'))
    assert !matcher.matches?([{ key_1: 'value_1', key_2: 'value_2' }])
  end
end
