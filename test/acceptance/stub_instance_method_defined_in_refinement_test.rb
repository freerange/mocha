require File.expand_path('../acceptance_test_helper', __FILE__)
require 'mocha/setup'

if Mocha::RUBY_V2_PLUS
  class StubInstanceMethodDefinedInRefinementTest < Mocha::TestCase
    include AcceptanceTest

    module RefiningModule
      refine Object do
        def my_public_method
          :original_return_value
        end

        def my_protected_method
          :original_return_value
        end
        protected :my_protected_method

        def my_private_method
          :original_return_value
        end
        protected :my_private_method
      end
    end

    using RefiningModule

    def setup
      setup_acceptance_test
    end

    def teardown
      teardown_acceptance_test
    end

    # rubocop:disable Lint/DuplicateMethods
    def test_should_stub_public_method_and_leave_it_unchanged_after_test
      instance = Class.new.new
      assert_snapshot_unchanged(instance) do
        test_result = run_as_test do
          instance.stubs(:my_public_method).returns(:new_return_value)
          assert_equal :new_return_value, instance.my_public_method
        end
        assert_passed(test_result)
      end
      assert_equal :original_return_value, instance.my_public_method
    end

    def test_should_stub_protected_method_and_leave_it_unchanged_after_test
      instance = Class.new.new
      assert_snapshot_unchanged(instance) do
        test_result = run_as_test do
          instance.stubs(:my_protected_method).returns(:new_return_value)
          assert_equal :new_return_value, instance.send(:my_protected_method)
        end
        assert_passed(test_result)
      end
      assert_equal :original_return_value, instance.send(:my_protected_method)
    end

    def test_should_stub_private_method_and_leave_it_unchanged_after_test
      instance = Class.new.new
      assert_snapshot_unchanged(instance) do
        test_result = run_as_test do
          instance.stubs(:my_private_method).returns(:new_return_value)
          assert_equal :new_return_value, instance.send(:my_private_method)
        end
        assert_passed(test_result)
      end
      assert_equal :original_return_value, instance.send(:my_private_method)
    end
    # rubocop:enable Lint/DuplicateMethods
  end
end
