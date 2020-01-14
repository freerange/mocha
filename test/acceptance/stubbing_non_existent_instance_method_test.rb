require File.expand_path('../stubbing_with_potential_violation_shared_tests', __FILE__)
require File.expand_path('../allow_stubbing_existing_method_shared_tests', __FILE__)

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
end

class AllowStubbingExistingInstanceMethodTest < Mocha::TestCase
  include AllowStubbingExistingMethodSharedTests

  def method_owner
    stub_owner.class
  end

  def stub_owner
    @stub_owner ||= Class.new.new
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
end

class AllowStubbingExistingInstanceSuperclassMethodTest < Mocha::TestCase
  include AllowStubbingExistingMethodSharedTests

  def method_owner
    stub_owner.class.superclass
  end

  def stub_owner
    @stub_owner ||= Class.new(Class.new).new
  end
end
