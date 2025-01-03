# frozen_string_literal: true

require File.expand_path('../acceptance_test_helper', __FILE__)

require 'execution_point'
require 'mocha/ruby_version'

class KeywordArgumentMatchingTest < Mocha::TestCase
  include AcceptanceTestHelper

  def setup
    setup_acceptance_test
  end

  def teardown
    teardown_acceptance_test
  end

  def test_should_match_hash_parameter_with_keyword_args
    execution_point = nil
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(key: 42); execution_point = ExecutionPoint.current
      Mocha::Configuration.override(strict_keyword_argument_matching: false) do
        capture_deprecation_warnings do
          mock.method({ key: 42 })
        end
      end
    end
    if Mocha::RUBY_V27_PLUS
      location = execution_point.location
      assert_includes test_result.deprecation_warnings.last, "Expectation defined at #{location} expected keyword arguments (key: 42)"
      assert_includes test_result.deprecation_warnings.last, 'but received positional hash ({key: 42})'
    end
    assert_passed(test_result)
  end

  if Mocha::RUBY_V27_PLUS
    def test_should_not_match_hash_parameter_with_keyword_args_when_strict_keyword_matching_is_enabled
      test_result = run_as_test do
        mock = mock()
        mock.expects(:method).with(key: 42)
        Mocha::Configuration.override(strict_keyword_argument_matching: true) do
          mock.method({ key: 42 })
        end
      end
      assert_failed(test_result)
    end
  end

  def test_should_match_hash_parameter_with_splatted_keyword_args
    execution_point = nil
    test_result = run_as_test do
      mock = mock()
      kwargs = { key: 42 }
      mock.expects(:method).with(**kwargs); execution_point = ExecutionPoint.current
      Mocha::Configuration.override(strict_keyword_argument_matching: false) do
        capture_deprecation_warnings do
          mock.method({ key: 42 })
        end
      end
    end
    if Mocha::RUBY_V27_PLUS
      location = execution_point.location
      assert_includes test_result.deprecation_warnings.last, "Expectation defined at #{location} expected keyword arguments (key: 42)"
      assert_includes test_result.deprecation_warnings.last, 'but received positional hash ({key: 42})'
    end
    assert_passed(test_result)
  end

  if Mocha::RUBY_V27_PLUS
    def test_should_not_match_hash_parameter_with_splatted_keyword_args_when_strict_keyword_matching_is_enabled
      test_result = run_as_test do
        mock = mock()
        kwargs = { key: 42 }
        mock.expects(:method).with(**kwargs)
        Mocha::Configuration.override(strict_keyword_argument_matching: true) do
          mock.method({ key: 42 })
        end
      end
      assert_failed(test_result)
    end
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

  def test_should_match_positional_and_keyword_args_with_last_positional_hash
    execution_point = nil
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(1, { key: 42 }); execution_point = ExecutionPoint.current
      Mocha::Configuration.override(strict_keyword_argument_matching: false) do
        capture_deprecation_warnings do
          mock.method(1, key: 42)
        end
      end
    end
    if Mocha::RUBY_V27_PLUS
      location = execution_point.location
      assert_includes test_result.deprecation_warnings.last, "Expectation defined at #{location} expected positional hash ({key: 42})"
      assert_includes test_result.deprecation_warnings.last, 'but received keyword arguments (key: 42)'
    end
    assert_passed(test_result)
  end

  if Mocha::RUBY_V27_PLUS
    def test_should_not_match_positional_and_keyword_args_with_last_positional_hash_when_strict_keyword_args_is_enabled
      test_result = run_as_test do
        mock = mock()
        mock.expects(:method).with(1, { key: 42 })
        Mocha::Configuration.override(strict_keyword_argument_matching: true) do
          mock.method(1, key: 42)
        end
      end
      assert_failed(test_result)
    end
  end

  def test_should_match_last_positional_hash_with_keyword_args
    execution_point = nil
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(1, key: 42); execution_point = ExecutionPoint.current
      Mocha::Configuration.override(strict_keyword_argument_matching: false) do
        capture_deprecation_warnings do
          mock.method(1, { key: 42 })
        end
      end
    end
    if Mocha::RUBY_V27_PLUS
      location = execution_point.location
      assert_includes test_result.deprecation_warnings.last, "Expectation defined at #{location} expected keyword arguments (key: 42)"
      assert_includes test_result.deprecation_warnings.last, 'but received positional hash ({key: 42})'
    end
    assert_passed(test_result)
  end

  if Mocha::RUBY_V27_PLUS
    def test_should_not_match_last_positional_hash_with_keyword_args_when_strict_keyword_args_is_enabled
      test_result = run_as_test do
        mock = mock()
        mock.expects(:method).with(1, key: 42)
        Mocha::Configuration.override(strict_keyword_argument_matching: true) do
          mock.method(1, { key: 42 })
        end
      end
      assert_failed(test_result)
    end
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

  if Mocha::RUBY_V27_PLUS
    def test_should_not_match_non_hash_args_with_keyword_args
      test_result = run_as_test do
        mock = mock()
        kwargs = { key: 1 }
        mock.expects(:method).with(**kwargs)
        Mocha::Configuration.override(strict_keyword_argument_matching: true) do
          mock.method([2])
        end
      end
      assert_failed(test_result)
    end
  end
end
