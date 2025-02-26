# frozen_string_literal: true

require File.expand_path('../acceptance_test_helper', __FILE__)
require 'mocha/configuration'

class StubbingNonExistentInstanceMethodTest < Mocha::TestCase
  include AcceptanceTestHelper

  def setup
    setup_acceptance_test
  end

  def teardown
    teardown_acceptance_test
  end

  def test_should_allow_stubbing_non_existent_instance_method
    Mocha.configure { |c| c.stubbing_non_existent_method = :allow }
    instance = Class.new.new
    test_result = run_as_test do
      instance.stubs(:non_existent_method)
    end
    assert !@logger.warnings.include?("stubbing non-existent method: #{instance.mocha_inspect}.non_existent_method")
    assert_passed(test_result)
  end

  def test_should_warn_when_stubbing_non_existent_instance_method
    Mocha.configure { |c| c.stubbing_non_existent_method = :warn }
    instance = Class.new.new
    test_result = run_as_test do
      instance.stubs(:non_existent_method)
    end
    assert_passed(test_result)
    assert @logger.warnings.include?("stubbing non-existent method: #{instance.mocha_inspect}.non_existent_method")
  end

  def test_should_prevent_stubbing_non_existent_instance_method
    Mocha.configure { |c| c.stubbing_non_existent_method = :prevent }
    instance = Class.new.new
    test_result = run_as_test do
      instance.stubs(:non_existent_method)
    end
    assert_errored(test_result)
    assert test_result.error_messages.include?("Mocha::StubbingError: stubbing non-existent method: #{instance.mocha_inspect}.non_existent_method")
  end

  def test_should_default_to_allow_stubbing_non_existent_instance_method
    instance = Class.new.new
    test_result = run_as_test do
      instance.stubs(:non_existent_method)
    end
    assert !@logger.warnings.include?("stubbing non-existent method: #{instance.mocha_inspect}.non_existent_method")
    assert_passed(test_result)
  end

  def test_should_allow_stubbing_existing_public_instance_method
    Mocha.configure { |c| c.stubbing_non_existent_method = :prevent }
    klass = Class.new do
      def existing_public_method; end
      public :existing_public_method
    end
    instance = klass.new
    test_result = run_as_test do
      instance.stubs(:existing_public_method)
    end
    assert_passed(test_result)
  end

  def test_should_allow_stubbing_method_to_which_instance_responds
    Mocha.configure { |c| c.stubbing_non_existent_method = :prevent }
    klass = Class.new do
      def respond_to_missing?(method, _include_all = false)
        (method == :method_to_which_instance_responds)
      end
    end
    instance = klass.new
    test_result = run_as_test do
      instance.stubs(:method_to_which_instance_responds)
    end
    assert_passed(test_result)
  end

  def test_should_allow_stubbing_existing_protected_instance_method
    Mocha.configure { |c| c.stubbing_non_existent_method = :prevent }
    klass = Class.new do
      def existing_protected_method; end
      protected :existing_protected_method
    end
    instance = klass.new
    test_result = run_as_test do
      instance.stubs(:existing_protected_method)
    end
    assert_passed(test_result)
  end

  def test_should_allow_stubbing_existing_private_instance_method
    Mocha.configure { |c| c.stubbing_non_existent_method = :prevent }
    klass = Class.new do
      def existing_private_method; end
      private :existing_private_method
    end
    instance = klass.new
    test_result = run_as_test do
      instance.stubs(:existing_private_method)
    end
    assert_passed(test_result)
  end

  def test_should_allow_stubbing_existing_public_instance_superclass_method
    Mocha.configure { |c| c.stubbing_non_existent_method = :prevent }
    superklass = Class.new do
      def existing_public_method; end
      public :existing_public_method
    end
    instance = Class.new(superklass).new
    test_result = run_as_test do
      instance.stubs(:existing_public_method)
    end
    assert_passed(test_result)
  end

  def test_should_allow_stubbing_existing_protected_instance_superclass_method
    Mocha.configure { |c| c.stubbing_non_existent_method = :prevent }
    superklass = Class.new do
      def existing_protected_method; end
      protected :existing_protected_method
    end
    instance = Class.new(superklass).new
    test_result = run_as_test do
      instance.stubs(:existing_protected_method)
    end
    assert_passed(test_result)
  end

  def test_should_allow_stubbing_existing_private_instance_superclass_method
    Mocha.configure { |c| c.stubbing_non_existent_method = :prevent }
    superklass = Class.new do
      def existing_private_method; end
      private :existing_private_method
    end
    instance = Class.new(superklass).new
    test_result = run_as_test do
      instance.stubs(:existing_private_method)
    end
    assert_passed(test_result)
  end
end
