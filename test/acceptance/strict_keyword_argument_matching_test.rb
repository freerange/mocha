# frozen_string_literal: true

require File.expand_path('../acceptance_test_helper', __FILE__)

require 'mocha/ruby_version'
require 'mocha/configuration'

if Mocha::RUBY_V27_PLUS
  class StrictKeywordArgumentMatchingTest < Mocha::TestCase
    include AcceptanceTestHelper

    def setup
      setup_acceptance_test
      Mocha.configure { |c| c.strict_keyword_argument_matching = true }
    end

    def teardown
      teardown_acceptance_test
    end

    def test_should_not_match_hash_parameter_with_keyword_args
      test_result = run_as_test do
        mock = mock()
        mock.expects(:method).with(key: 42)
        mock.method({ key: 42 })
      end
      assert_failed(test_result)
    end

    def test_should_not_match_hash_parameter_with_splatted_keyword_args
      test_result = run_as_test do
        mock = mock()
        kwargs = { key: 42 }
        mock.expects(:method).with(**kwargs)
        mock.method({ key: 42 })
      end
      assert_failed(test_result)
    end

    def test_should_not_match_positional_and_keyword_args_with_last_positional_hash
      test_result = run_as_test do
        mock = mock()
        mock.expects(:method).with(1, { key: 42 })
        mock.method(1, key: 42)
      end
      assert_passed(test_result)
    end

    def test_should_not_match_last_positional_hash_with_keyword_args
      test_result = run_as_test do
        mock = mock()
        mock.expects(:method).with(1, key: 42)
        mock.method(1, { key: 42 })
      end
      assert_failed(test_result)
    end

    def test_should_not_match_non_hash_args_with_keyword_args
      test_result = run_as_test do
        mock = mock()
        kwargs = { key: 1 }
        mock.expects(:method).with(**kwargs)
        mock.method([2])
      end
      assert_failed(test_result)
    end
  end
end
