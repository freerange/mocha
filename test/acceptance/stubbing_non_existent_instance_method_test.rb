require File.expand_path('../stubbing_with_potential_violation_shared_tests', __FILE__)

class StubbingNonExistentInstanceMethodTest < Mocha::TestCase
  include StubbingWithPotentialViolationDefaultingToAllowedSharedTests

  def setup
    super
    @instance = Class.new.new
  end

  def configure_violation(config, treatment)
    config.stubbing_non_existent_method = treatment
  end

  def potential_violation
    @instance.stubs(:non_existent_method)
  end

  def message_on_violation
    "stubbing non-existent method: #{@instance.mocha_inspect}.non_existent_method"
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
      def respond_to?(method, _include_private = false)
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
