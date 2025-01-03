# frozen_string_literal: true

require File.expand_path('../acceptance_test_helper', __FILE__)

require 'execution_point'
require 'mocha/ruby_version'

class LooseKeywordArgumentMatchingTest < Mocha::TestCase
  include AcceptanceTestHelper

  def setup
    setup_acceptance_test
    Mocha.configure { |c| c.strict_keyword_argument_matching = false } if Mocha::RUBY_V27_PLUS
  end

  def teardown
    teardown_acceptance_test
  end

  def test_should_match_hash_parameter_with_keyword_args
    execution_point = nil
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(key: 42); execution_point = ExecutionPoint.current
      capture_deprecation_warnings do
        mock.method({ key: 42 })
      end
    end
    if Mocha::RUBY_V27_PLUS
      location = execution_point.location
      assert_includes test_result.last_deprecation_warning, "Expectation defined at #{location} expected keyword arguments (key: 42)"
      assert_includes test_result.last_deprecation_warning, 'but received positional hash ({key: 42})'
    end
    assert_passed(test_result)
  end

  def test_should_match_hash_parameter_with_splatted_keyword_args
    execution_point = nil
    test_result = run_as_test do
      mock = mock()
      kwargs = { key: 42 }
      mock.expects(:method).with(**kwargs); execution_point = ExecutionPoint.current
      capture_deprecation_warnings do
        mock.method({ key: 42 })
      end
    end
    if Mocha::RUBY_V27_PLUS
      location = execution_point.location
      assert_includes test_result.last_deprecation_warning, "Expectation defined at #{location} expected keyword arguments (key: 42)"
      assert_includes test_result.last_deprecation_warning, 'but received positional hash ({key: 42})'
    end
    assert_passed(test_result)
  end

  def test_should_match_positional_and_keyword_args_with_last_positional_hash
    execution_point = nil
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(1, { key: 42 }); execution_point = ExecutionPoint.current
      capture_deprecation_warnings do
        mock.method(1, key: 42)
      end
    end
    if Mocha::RUBY_V27_PLUS
      location = execution_point.location
      assert_includes test_result.last_deprecation_warning, "Expectation defined at #{location} expected positional hash ({key: 42})"
      assert_includes test_result.last_deprecation_warning, 'but received keyword arguments (key: 42)'
    end
    assert_passed(test_result)
  end

  def test_should_match_last_positional_hash_with_keyword_args
    execution_point = nil
    test_result = run_as_test do
      mock = mock()
      mock.expects(:method).with(1, key: 42); execution_point = ExecutionPoint.current
      capture_deprecation_warnings do
        mock.method(1, { key: 42 })
      end
    end
    if Mocha::RUBY_V27_PLUS
      location = execution_point.location
      assert_includes test_result.last_deprecation_warning, "Expectation defined at #{location} expected keyword arguments (key: 42)"
      assert_includes test_result.last_deprecation_warning, 'but received positional hash ({key: 42})'
    end
    assert_passed(test_result)
  end
end
