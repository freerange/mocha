require File.expand_path('../stubbing_with_potential_violation_shared_tests', __FILE__)

class StubbingNonExistentAnyInstanceMethodTest < Mocha::TestCase
  include StubbingWithPotentialViolationDefaultingToAllowedSharedTests

  def setup
    super
    @klass = Class.new
  end

  def configure_violation(config, treatment)
    config.stubbing_non_existent_method = treatment
  end

  def potential_violation
    @klass.any_instance.stubs(:non_existent_method)
  end

  def message_on_violation
    "stubbing non-existent method: #{@klass.any_instance.mocha_inspect}.non_existent_method"
  end
end

module AllowStubbingExistingAnyInstanceMethodSharedTests
  include AcceptanceTest

  def setup
    setup_acceptance_test
  end

  def teardown
    teardown_acceptance_test
  end

  def test_should_allow_stubbing_existing_public_any_instance_method
    assert_allows_stubbing_existing_any_instance_method(:public)
  end

  def test_should_allow_stubbing_existing_protected_any_instance_method
    assert_allows_stubbing_existing_any_instance_method(:protected)
  end

  def test_should_allow_stubbing_existing_private_any_instance_method
    assert_allows_stubbing_existing_any_instance_method(:private)
  end

  def assert_allows_stubbing_existing_any_instance_method(visibility)
    Mocha.configure { |c| c.stubbing_non_existent_method = :prevent }
    method_owner.send(:define_method, :existing_method) {}
    method_owner.send(visibility, :existing_method)
    stub_owner_in_scope = stub_owner
    test_result = run_as_test do
      stub_owner_in_scope.stubs(:existing_method)
    end
    assert_passed(test_result)
  end
end

class AllowStubbingExistingAnyInstanceMethodTest < Mocha::TestCase
  include AllowStubbingExistingAnyInstanceMethodSharedTests

  def method_owner
    stubbed_instance
  end

  def stub_owner
    stubbed_instance.any_instance
  end

  def stubbed_instance
    @stubbed_instance ||= Class.new
  end

  def test_should_allow_stubbing_method_to_which_any_instance_responds
    klass = Class.new do
      def respond_to?(method, _include_private = false)
        (method == :method_to_which_instance_responds)
      end
    end
    Mocha.configure { |c| c.stubbing_non_existent_method = :prevent }
    test_result = run_as_test do
      klass.any_instance.stubs(:method_to_which_instance_responds)
    end
    assert_passed(test_result)
  end

  def test_should_default_to_allowing_stubbing_method_if_responds_to_depends_on_calling_initialize
    klass = Class.new do
      def initialize(attrs = {})
        @attributes = attrs
      end

      def respond_to?(method, _include_private = false)
        @attributes.key?(method) ? @attributes[method] : super
      end
    end
    test_result = run_as_test do
      klass.any_instance.stubs(:foo)
    end
    assert_passed(test_result)
  end
end

class AllowStubbingExistingAnyInstanceSuperclassMethodTest < Mocha::TestCase
  include AllowStubbingExistingAnyInstanceMethodSharedTests

  def method_owner
    stubbed_instance.superclass
  end

  def stub_owner
    stubbed_instance.any_instance
  end

  def stubbed_instance
    @stubbed_instance ||= Class.new(Class.new)
  end
end
