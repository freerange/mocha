require File.expand_path('../acceptance_test_helper', __FILE__)
require 'mocha/configuration'

if RUBY_VERSION < '2.2.0'
  class StubbingNilTest < Mocha::TestCase
    include AcceptanceTest

    def setup
      setup_acceptance_test
    end

    def teardown
      teardown_acceptance_test
    end

    def test_should_allow_stubbing_method_on_nil
      assert_passed(stub_method_on_nil(:allow))
      assert !@logger.warnings.include?(violation_message)
    end

    def test_should_warn_on_stubbing_method_on_nil
      assert_passed(stub_method_on_nil(:warn))
      assert @logger.warnings.include?(violation_message)
    end

    def test_should_prevent_stubbing_method_on_nil
      test_result = stub_method_on_nil(:prevent)
      assert_failed(test_result)
      assert test_result.error_messages.include?("Mocha::StubbingError: #{violation_message}")
    end

    def test_should_default_to_prevent_stubbing_method_on_non_mock_object
      test_result = stub_method_on_nil
      assert_failed(test_result)
      assert test_result.error_messages.include?("Mocha::StubbingError: #{violation_message}")
    end

    def test_should_allow_stubbing_method_on_non_nil_object
      test_result = run_test_with_check(:prevent) do
        Object.new.stubs(:stubbed_method)
      end
      assert_passed(test_result)
    end

    def stub_method_on_nil(treatment = :default)
      run_test_with_check(treatment) do
        nil.stubs(:stubbed_method)
      end
    end

    def run_test_with_check(treatment = :default, &block)
      Mocha.configure { |c| c.stubbing_method_on_nil = treatment } unless treatment == :default
      run_as_test(&block)
    end

    def violation_message
      'stubbing method on nil: nil.stubbed_method'
    end
  end
end
