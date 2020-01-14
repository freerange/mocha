require File.expand_path('../stubbing_with_potential_violation_shared_tests', __FILE__)
require File.expand_path('../allow_stubbing_existing_method_shared_tests', __FILE__)

class StubbingNonExistentClassMethodTest < Mocha::TestCase
  include StubbingWithPotentialViolationDefaultingToAllowedSharedTests

  def setup
    super
    @klass = Class.new
  end

  def configure_violation(config, treatment)
    config.stubbing_non_existent_method = treatment
  end

  def potential_violation
    @klass.stubs(:non_existent_method)
  end

  def message_on_violation
    "stubbing non-existent method: #{@klass.mocha_inspect}.non_existent_method"
  end
end

class AllowStubbingExistingClassMethodTest < Mocha::TestCase
  include AllowStubbingExistingMethodSharedTests

  def method_owner
    stub_owner.singleton_class
  end

  def stub_owner
    @stub_owner ||= Class.new
  end

  def test_should_allow_stubbing_method_to_which_class_responds
    Mocha.configure { |c| c.stubbing_non_existent_method = :prevent }
    klass = Class.new do
      class << self
        def respond_to?(method, _include_private = false)
          (method == :method_to_which_class_responds)
        end
      end
    end
    test_result = run_as_test do
      klass.stubs(:method_to_which_class_responds)
    end
    assert_passed(test_result)
  end
end

class AllowStubbingExistingSuperclassMethodTest < Mocha::TestCase
  include AllowStubbingExistingMethodSharedTests

  def method_owner
    stub_owner.superclass.singleton_class
  end

  def stub_owner
    @stub_owner ||= Class.new(Class.new)
  end
end
