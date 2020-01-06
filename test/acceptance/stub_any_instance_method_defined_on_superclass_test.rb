require File.expand_path('../stub_method_shared_tests', __FILE__)

class StubAnyInstanceMethodDefinedOnSuperclassTest < Mocha::TestCase
  include StubMethodSharedTests

  def method_owner
    stubbed_instance.class.superclass
  end

  def stubbed_instance
    @stubbed_instance ||= Class.new(Class.new).new
  end

  def stub_owner
    stubbed_instance.class.any_instance
  end

  def test_expect_method_on_any_instance_of_superclass_even_if_preceded_by_test_expecting_method_on_any_instance_of_subclass
    superklass = Class.new do
      def self.inspect
        'superklass'
      end

      def my_instance_method; end
    end
    klass = Class.new(superklass) do
      def self.inspect
        'klass'
      end

      def my_instance_method; end
    end
    test_result = run_as_tests(
      :test_1 => lambda {
        klass.any_instance.expects(:my_instance_method)
        klass.new.my_instance_method
      },
      :test_2 => lambda {
        superklass.any_instance.expects(:my_instance_method)
      }
    )
    assert_failed(test_result)
    assert_equal [
      'not all expectations were satisfied',
      'unsatisfied expectations:',
      '- expected exactly once, invoked never: #<AnyInstance:superklass>.my_instance_method(any_parameters)'
    ], test_result.failure_message_lines
  end
end

class StubSuperclassAnyInstanceMethodDefinedOnSuperclassTest < Mocha::TestCase
  include StubMethodSharedTests

  def method_owner
    stubbed_instance.class.superclass
  end

  def stubbed_instance
    @stubbed_instance ||= Class.new(Class.new).new
  end

  def stub_owner
    method_owner.any_instance
  end
end
