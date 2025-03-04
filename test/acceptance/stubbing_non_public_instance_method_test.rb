# frozen_string_literal: true

require File.expand_path('../acceptance_test_helper', __FILE__)
require 'mocha/configuration'

class StubbingNonPublicInstanceMethodTest < Mocha::TestCase
  include AcceptanceTestHelper

  def setup
    setup_acceptance_test
  end

  def teardown
    teardown_acceptance_test
  end

  def test_should_allow_stubbing_private_instance_method
    Mocha.configure { |c| c.stubbing_non_public_method = :allow }
    instance = Class.new do
      def private_method; end
      private :private_method
    end.new
    test_result = run_as_test do
      instance.stubs(:private_method)
    end
    assert_passed(test_result)
    assert !@logger.warnings.include?("stubbing non-public method: #{instance.mocha_inspect}.private_method")
  end

  def test_should_allow_stubbing_protected_instance_method
    Mocha.configure { |c| c.stubbing_non_public_method = :allow }
    instance = Class.new do
      def protected_method; end
      protected :protected_method
    end.new
    test_result = run_as_test do
      instance.stubs(:protected_method)
    end
    assert_passed(test_result)
    assert !@logger.warnings.include?("stubbing non-public method: #{instance.mocha_inspect}.protected_method")
  end

  def test_should_warn_when_stubbing_private_instance_method
    Mocha.configure { |c| c.stubbing_non_public_method = :warn }
    instance = Class.new do
      def private_method; end
      private :private_method
    end.new
    test_result = run_as_test do
      instance.stubs(:private_method)
    end
    assert_passed(test_result)
    assert @logger.warnings.include?("stubbing non-public method: #{instance.mocha_inspect}.private_method")
  end

  def test_should_warn_when_stubbing_protected_instance_method
    Mocha.configure { |c| c.stubbing_non_public_method = :warn }
    instance = Class.new do
      def protected_method; end
      protected :protected_method
    end.new
    test_result = run_as_test do
      instance.stubs(:protected_method)
    end
    assert_passed(test_result)
    assert @logger.warnings.include?("stubbing non-public method: #{instance.mocha_inspect}.protected_method")
  end

  def test_should_prevent_stubbing_private_instance_method
    Mocha.configure { |c| c.stubbing_non_public_method = :prevent }
    instance = Class.new do
      def private_method; end
      private :private_method
    end.new
    test_result = run_as_test do
      instance.stubs(:private_method)
    end
    assert_errored(test_result)
    assert test_result.error_messages.include?("Mocha::StubbingError: stubbing non-public method: #{instance.mocha_inspect}.private_method")
  end

  def test_should_prevent_stubbing_protected_instance_method
    Mocha.configure { |c| c.stubbing_non_public_method = :prevent }
    instance = Class.new do
      def protected_method; end
      protected :protected_method
    end.new
    test_result = run_as_test do
      instance.stubs(:protected_method)
    end
    assert_errored(test_result)
    assert test_result.error_messages.include?("Mocha::StubbingError: stubbing non-public method: #{instance.mocha_inspect}.protected_method")
  end

  def test_should_default_to_allow_stubbing_private_instance_method
    instance = Class.new do
      def private_method; end
      private :private_method
    end.new
    test_result = run_as_test do
      instance.stubs(:private_method)
    end
    assert_passed(test_result)
    assert !@logger.warnings.include?("stubbing non-public method: #{instance.mocha_inspect}.private_method")
  end

  def test_should_default_to_allow_stubbing_protected_instance_method
    instance = Class.new do
      def protected_method; end
      protected :protected_method
    end.new
    test_result = run_as_test do
      instance.stubs(:protected_method)
    end
    assert_passed(test_result)
    assert !@logger.warnings.include?("stubbing non-public method: #{instance.mocha_inspect}.protected_method")
  end

  def test_should_allow_stubbing_public_instance_method
    Mocha.configure { |c| c.stubbing_non_public_method = :prevent }
    instance = Class.new do
      def public_method; end
      public :public_method
    end.new
    test_result = run_as_test do
      instance.stubs(:public_method)
    end
    assert_passed(test_result)
  end

  def test_should_allow_stubbing_method_to_which_instance_responds
    Mocha.configure { |c| c.stubbing_non_public_method = :prevent }
    instance = Class.new do
      def respond_to_missing?(method, _include_all = false)
        (method == :method_to_which_instance_responds)
      end
    end.new
    test_result = run_as_test do
      instance.stubs(:method_to_which_instance_responds)
    end
    assert_passed(test_result)
  end
end
