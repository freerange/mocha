# frozen_string_literal: true

require File.expand_path('../acceptance_test_helper', __FILE__)
require 'mocha/configuration'

class StubbingNonExistentClassMethodTest < Mocha::TestCase
  include AcceptanceTestHelper

  def setup
    setup_acceptance_test
  end

  def teardown
    teardown_acceptance_test
  end

  def test_should_allow_stubbing_non_existent_class_method
    Mocha.configure { |c| c.stubbing_non_existent_method = :allow }
    klass = Class.new
    test_result, stderr = run_as_test_capturing_stderr do
      klass.stubs(:non_existent_method)
    end
    assert !stderr.include?("stubbing non-existent method: #{klass.mocha_inspect}.non_existent_method")
    assert_passed(test_result)
  end

  def test_should_warn_when_stubbing_non_existent_class_method
    Mocha.configure { |c| c.stubbing_non_existent_method = :warn }
    klass = Class.new
    test_result, stderr = run_as_test_capturing_stderr do
      klass.stubs(:non_existent_method)
    end
    assert_passed(test_result)
    assert stderr.include?("stubbing non-existent method: #{klass.mocha_inspect}.non_existent_method")
  end

  def test_should_prevent_stubbing_non_existent_class_method
    Mocha.configure { |c| c.stubbing_non_existent_method = :prevent }
    klass = Class.new
    test_result = run_as_test do
      klass.stubs(:non_existent_method)
    end
    assert_errored(test_result)
    assert test_result.error_messages.include?("Mocha::StubbingError: stubbing non-existent method: #{klass.mocha_inspect}.non_existent_method")
  end

  def test_should_default_to_allow_stubbing_non_existent_class_method
    klass = Class.new
    test_result, stderr = run_as_test_capturing_stderr do
      klass.stubs(:non_existent_method)
    end
    assert !stderr.include?("stubbing non-existent method: #{klass.mocha_inspect}.non_existent_method")
    assert_passed(test_result)
  end

  def test_should_allow_stubbing_existing_public_class_method
    Mocha.configure { |c| c.stubbing_non_existent_method = :prevent }
    klass = Class.new do
      class << self
        def existing_public_method; end
        public :existing_public_method
      end
    end
    test_result = run_as_test do
      klass.stubs(:existing_public_method)
    end
    assert_passed(test_result)
  end

  def test_should_allow_stubbing_method_to_which_class_responds
    Mocha.configure { |c| c.stubbing_non_existent_method = :prevent }
    klass = Class.new do
      class << self
        def respond_to_missing?(method, _include_all = false)
          (method == :method_to_which_class_responds)
        end
      end
    end
    test_result = run_as_test do
      klass.stubs(:method_to_which_class_responds)
    end
    assert_passed(test_result)
  end

  def test_should_allow_stubbing_existing_protected_class_method
    Mocha.configure { |c| c.stubbing_non_existent_method = :prevent }
    klass = Class.new do
      class << self
        def existing_protected_method; end
        protected :existing_protected_method
      end
    end
    test_result = run_as_test do
      klass.stubs(:existing_protected_method)
    end
    assert_passed(test_result)
  end

  def test_should_allow_stubbing_existing_private_class_method
    Mocha.configure { |c| c.stubbing_non_existent_method = :prevent }
    klass = Class.new do
      class << self
        def existing_private_method; end
        private :existing_private_method
      end
    end
    test_result = run_as_test do
      klass.stubs(:existing_private_method)
    end
    assert_passed(test_result)
  end

  def test_should_allow_stubbing_existing_public_superclass_method
    Mocha.configure { |c| c.stubbing_non_existent_method = :prevent }
    superklass = Class.new do
      class << self
        def existing_public_method; end
        public :existing_public_method
      end
    end
    klass = Class.new(superklass)
    test_result = run_as_test do
      klass.stubs(:existing_public_method)
    end
    assert_passed(test_result)
  end

  def test_should_allow_stubbing_existing_protected_superclass_method
    Mocha.configure { |c| c.stubbing_non_existent_method = :prevent }
    superklass = Class.new do
      class << self
        def existing_protected_method; end
        protected :existing_protected_method
      end
    end
    klass = Class.new(superklass)
    test_result = run_as_test do
      klass.stubs(:existing_protected_method)
    end
    assert_passed(test_result)
  end

  def test_should_allow_stubbing_existing_private_superclass_method
    Mocha.configure { |c| c.stubbing_non_existent_method = :prevent }
    superklass = Class.new do
      class << self
        def existing_private_method; end
        protected :existing_private_method
      end
    end
    klass = Class.new(superklass)
    test_result = run_as_test do
      klass.stubs(:existing_private_method)
    end
    assert_passed(test_result)
  end
end
