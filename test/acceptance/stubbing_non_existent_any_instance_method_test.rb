require File.expand_path('../stubbing_with_potential_violation_shared_tests', __FILE__)
require File.expand_path('../stubbing_existing_method_is_allowed_shared_tests', __FILE__)

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

class StubbingExistingAnyInstanceMethodIsAllowedTest < Mocha::TestCase
  include StubbingExistingMethodIsAllowedSharedTests

  def method_owner
    @method_owner ||= Class.new
  end

  def stub_owner
    method_owner.any_instance
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

class StubbingExistingAnyInstanceSuperclassMethodIsAllowedTest < Mocha::TestCase
  include StubbingExistingMethodIsAllowedSharedTests

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
