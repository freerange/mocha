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

  def test_should_allow_stubbing_existing_public_any_instance_method
    Mocha.configure { |c| c.stubbing_non_existent_method = :prevent }
    klass = Class.new do
      def existing_public_method; end
      public :existing_public_method
    end
    test_result = run_as_test do
      klass.any_instance.stubs(:existing_public_method)
    end
    assert_passed(test_result)
  end

  def test_should_allow_stubbing_method_to_which_any_instance_responds
    Mocha.configure { |c| c.stubbing_non_existent_method = :prevent }
    klass = Class.new do
      def respond_to?(method, _include_private = false)
        (method == :method_to_which_instance_responds)
      end
    end
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

  def test_should_allow_stubbing_existing_protected_any_instance_method
    Mocha.configure { |c| c.stubbing_non_existent_method = :prevent }
    klass = Class.new do
      def existing_protected_method; end
      protected :existing_protected_method
    end
    test_result = run_as_test do
      klass.any_instance.stubs(:existing_protected_method)
    end
    assert_passed(test_result)
  end

  def test_should_allow_stubbing_existing_private_any_instance_method
    Mocha.configure { |c| c.stubbing_non_existent_method = :prevent }
    klass = Class.new do
      def existing_private_method; end
      private :existing_private_method
    end
    test_result = run_as_test do
      klass.any_instance.stubs(:existing_private_method)
    end
    assert_passed(test_result)
  end

  def test_should_allow_stubbing_existing_public_any_instance_superclass_method
    Mocha.configure { |c| c.stubbing_non_existent_method = :prevent }
    superklass = Class.new do
      def existing_public_method; end
      public :existing_public_method
    end
    klass = Class.new(superklass)
    test_result = run_as_test do
      klass.any_instance.stubs(:existing_public_method)
    end
    assert_passed(test_result)
  end

  def test_should_allow_stubbing_existing_protected_any_instance_superclass_method
    Mocha.configure { |c| c.stubbing_non_existent_method = :prevent }
    superklass = Class.new do
      def existing_protected_method; end
      protected :existing_protected_method
    end
    klass = Class.new(superklass)
    test_result = run_as_test do
      klass.any_instance.stubs(:existing_protected_method)
    end
    assert_passed(test_result)
  end

  def test_should_allow_stubbing_existing_private_any_instance_superclass_method
    Mocha.configure { |c| c.stubbing_non_existent_method = :prevent }
    superklass = Class.new do
      def existing_private_method; end
      private :existing_private_method
    end
    klass = Class.new(superklass)
    test_result = run_as_test do
      klass.any_instance.stubs(:existing_private_method)
    end
    assert_passed(test_result)
  end
end
