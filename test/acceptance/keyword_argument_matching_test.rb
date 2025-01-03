# frozen_string_literal: true

require File.expand_path('../acceptance_test_helper', __FILE__)

class KeywordArgumentMatchingTest < Mocha::TestCase
  include AcceptanceTestHelper

  def setup
    setup_acceptance_test
  end

  def teardown
    teardown_acceptance_test
  end

  def test_should_match_splatted_hash_parameter_with_keyword_args
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(key: 42)
      kwargs = { key: 42 }
      mock.method(**kwargs)
    end
    assert_passed(test_result)
  end

  def test_should_match_splatted_hash_parameter_with_splatted_hash
    test_result = run_as_test do
      mock = mock()
      kwargs = { key: 42 }
      mock.expects(:method).with(**kwargs)
      mock.method(**kwargs)
    end
    assert_passed(test_result)
  end

  def test_should_match_positional_and_keyword_args_with_keyword_args
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(1, key: 42)
      mock.method(1, key: 42)
    end
    assert_passed(test_result)
  end

  def test_should_match_hash_parameter_with_hash_matcher
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(has_key(:key))
      mock.method({ key: 42 })
    end
    assert_passed(test_result)
  end

  def test_should_match_splatted_hash_parameter_with_hash_matcher
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(has_key(:key))
      kwargs = { key: 42 }
      mock.method(**kwargs)
    end
    assert_passed(test_result)
  end

  def test_should_match_positional_and_keyword_args_with_hash_matcher
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(1, has_key(:key))
      mock.method(1, key: 42)
    end
    assert_passed(test_result)
  end

  def test_should_match_keyword_args_with_nested_matcher
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(key: is_a(Integer))
      mock.method(key: 42)
    end
    assert_passed(test_result)
  end

  def test_should_match_keyword_args_with_matcher_built_using_keyword_args
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(has_entry(:k1, k2: 'v2'))
      mock.method(k1: { k2: 'v2' })
    end
    assert_passed(test_result)
  end

  def test_should_not_match_keyword_args_with_matcher_built_using_keyword_args
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(has_entry(:k1, k2: 'v2'))
      mock.method(k1: { k2: 'v2', k3: 'v3' })
    end
    assert_failed(test_result)
  end

  def test_should_match_last_positional_hash_with_hash_matcher
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(1, has_key(:key))
      mock.method(1, { key: 42 })
    end
    assert_passed(test_result)
  end
end
