require File.expand_path('../stubbing_non_existent_method_is_checked', __FILE__)
require File.expand_path('../stubbing_existing_method_is_allowed', __FILE__)
require File.expand_path('../stubbing_any_instance_method', __FILE__)

class StubbingNonExistentAnyInstanceMethodTest < Mocha::TestCase
  include StubbingNonExistentMethodIsChecked
  include StubbingAnyInstanceMethod
end

class StubbingExistingAnyInstanceMethodIsAllowedTest < Mocha::TestCase
  include StubbingExistingMethodIsAllowed
  include StubbingAnyInstanceMethod

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
  include StubbingExistingMethodIsAllowed

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
