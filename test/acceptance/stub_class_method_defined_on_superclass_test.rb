require File.expand_path('../stub_method_shared_tests', __FILE__)

class StubClassMethodDefinedOnSuperclassTest < Mocha::TestCase
  include StubMethodSharedTests

  def method_owner
    stubbed_instance.superclass.singleton_class
  end

  def stubbed_instance
    @stubbed_instance ||= Class.new(Class.new)
  end

  def test_stub_on_earliest_receiver_should_take_priority
    superklass = Class.new do
      class << self
        def my_class_method
          :original_return_value
        end
      end
    end
    klass = Class.new(superklass)
    test_result = run_as_test do
      klass.stubs(:my_class_method).returns(:klass_return_value)
      superklass.stubs(:my_class_method).returns(:superklass_return_value)
      assert_equal :klass_return_value, klass.my_class_method
    end
    assert_passed(test_result)
  end

  def test_expect_method_on_superclass_even_if_preceded_by_test_expecting_method_on_subclass
    superklass = Class.new do
      def self.inspect
        'superklass'
      end

      def self.my_class_method; end
    end
    klass = Class.new(superklass) do
      def self.inspect
        'klass'
      end

      def self.my_class_method; end
    end
    test_result = run_as_tests(
      :test_1 => lambda {
        klass.expects(:my_class_method)
        klass.my_class_method
      },
      :test_2 => lambda {
        superklass.expects(:my_class_method)
      }
    )
    assert_failed(test_result)
    assert_equal [
      'not all expectations were satisfied',
      'unsatisfied expectations:',
      '- expected exactly once, invoked never: superklass.my_class_method(any_parameters)'
    ], test_result.failure_message_lines
  end
end

class StubSuperclassClassMethodDefinedOnSuperclassTest < Mocha::TestCase
  include StubMethodSharedTests

  def method_owner
    stubbed_instance.superclass.singleton_class
  end

  def stubbed_instance
    @stubbed_instance ||= Class.new(Class.new)
  end

  def stub_owner
    stubbed_instance.superclass
  end
end
