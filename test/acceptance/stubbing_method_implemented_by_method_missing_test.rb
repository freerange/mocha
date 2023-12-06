require File.expand_path('../acceptance_test_helper', __FILE__)

class StubbingMethodImplementedByMethodMissingTest < Mocha::TestCase
  include AcceptanceTest

  def setup
    setup_acceptance_test
  end

  def teardown
    teardown_acceptance_test
  end

  def test_stubs_method_implemented_using_method_missing
    object = Class.new do
      def method_missing(symbol, *)
        symbol == :foo ? :method_missing_value : super
      end

      def respond_to_missing?(symbol, *)
        symbol == :foo
      end
    end.new
    test_result = run_as_test do
      object.stubs(:foo).returns(:stubbed_value)
      assert_equal :stubbed_value, object.foo
    end
    assert_passed(test_result)
  end

  def test_stubs_method_implemented_using_method_missing_when_private_method_with_same_name_exists_on_superclass
    superclass = Class.new do
      def foo
        :superclass_value
      end
      private :foo
    end
    object = Class.new(superclass) do
      def method_missing(symbol, *)
        symbol == :foo ? :method_missing_value : super
      end

      def respond_to_missing?(symbol, *)
        symbol == :foo
      end
    end.new
    test_result = run_as_test do
      object.stubs(:foo).returns(:stubbed_value)
      assert_equal :stubbed_value, object.foo
      assert_equal :stubbed_value, object.public_send(:foo)
      assert_equal :superclass_value, object.send(:foo)
    end
    assert_passed(test_result)
  end
end
