# frozen_string_literal: true

require File.expand_path('../acceptance_test_helper', __FILE__)
require 'mocha/configuration'

class StubbingNonPublicAnyInstanceMethodTest < Mocha::TestCase
  include AcceptanceTestHelper

  def setup
    setup_acceptance_test
  end

  def teardown
    teardown_acceptance_test
  end

  def test_should_allow_stubbing_private_any_instance_method
    Mocha.configure { |c| c.stubbing_non_public_method = :allow }
    klass = Class.new do
      def private_method; end
      private :private_method
    end
    test_result = run_as_test do
      klass.any_instance.stubs(:private_method)
    end
    assert_passed(test_result)
    assert !@logger.warnings.include?("stubbing non-public method: #{klass.any_instance.mocha_inspect}.private_method")
  end

  def test_should_allow_stubbing_protected_any_instance_method
    Mocha.configure { |c| c.stubbing_non_public_method = :allow }
    klass = Class.new do
      def protected_method; end
      protected :protected_method
    end
    test_result = run_as_test do
      klass.any_instance.stubs(:protected_method)
    end
    assert_passed(test_result)
    assert !@logger.warnings.include?("stubbing non-public method: #{klass.any_instance.mocha_inspect}.protected_method")
  end

  def test_should_warn_when_stubbing_private_any_instance_method
    Mocha.configure { |c| c.stubbing_non_public_method = :warn }
    klass = Class.new do
      def private_method; end
      private :private_method
    end
    test_result = run_as_test do
      klass.any_instance.stubs(:private_method)
    end
    assert_passed(test_result)
    assert @logger.warnings.include?("stubbing non-public method: #{klass.any_instance.mocha_inspect}.private_method")
  end

  def test_should_warn_when_stubbing_protected_any_instance_method
    Mocha.configure { |c| c.stubbing_non_public_method = :warn }
    klass = Class.new do
      def protected_method; end
      protected :protected_method
    end
    test_result = run_as_test do
      klass.any_instance.stubs(:protected_method)
    end
    assert_passed(test_result)
    assert @logger.warnings.include?("stubbing non-public method: #{klass.any_instance.mocha_inspect}.protected_method")
  end

  def test_should_prevent_stubbing_private_any_instance_method
    Mocha.configure { |c| c.stubbing_non_public_method = :prevent }
    klass = Class.new do
      def private_method; end
      private :private_method
    end
    test_result = run_as_test do
      klass.any_instance.stubs(:private_method)
    end
    assert_errored(test_result)
    assert test_result.error_messages.include?("Mocha::StubbingError: stubbing non-public method: #{klass.any_instance.mocha_inspect}.private_method")
  end

  def test_should_prevent_stubbing_protected_any_instance_method
    Mocha.configure { |c| c.stubbing_non_public_method = :prevent }
    klass = Class.new do
      def protected_method; end
      protected :protected_method
    end
    test_result = run_as_test do
      klass.any_instance.stubs(:protected_method)
    end
    assert_errored(test_result)
    assert test_result.error_messages.include?("Mocha::StubbingError: stubbing non-public method: #{klass.any_instance.mocha_inspect}.protected_method")
  end

  def test_should_default_to_allow_stubbing_private_any_instance_method
    klass = Class.new do
      def private_method; end
      private :private_method
    end
    test_result = run_as_test do
      klass.any_instance.stubs(:private_method)
    end
    assert_passed(test_result)
    assert !@logger.warnings.include?("stubbing non-public method: #{klass.any_instance.mocha_inspect}.private_method")
  end

  def test_should_default_to_allow_stubbing_protected_any_instance_method
    klass = Class.new do
      def protected_method; end
      protected :protected_method
    end
    test_result = run_as_test do
      klass.any_instance.stubs(:protected_method)
    end
    assert_passed(test_result)
    assert !@logger.warnings.include?("stubbing non-public method: #{klass.any_instance.mocha_inspect}.protected_method")
  end

  def test_should_allow_stubbing_public_any_instance_method
    Mocha.configure { |c| c.stubbing_non_public_method = :prevent }
    klass = Class.new do
      def public_method; end
      public :public_method
    end
    test_result = run_as_test do
      klass.any_instance.stubs(:public_method)
    end
    assert_passed(test_result)
  end
end
