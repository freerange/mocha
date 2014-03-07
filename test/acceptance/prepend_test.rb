require File.expand_path('../acceptance_test_helper', __FILE__)
require 'mocha/setup'

class PrependTest < Mocha::TestCase

  include AcceptanceTest

  def setup
    setup_acceptance_test
  end

  def teardown
    teardown_acceptance_test
  end

  def test_stubbing_a_prepended_method
    mod = Module.new do
      def my_method
        super + " World"
      end
    end
    klass = Class.new do
      prepend mod
      def my_method
        "Hello"
      end
    end
    assert_snapshot_unchanged(klass) do
      test_result = run_as_test do
        klass.any_instance.stubs(:my_method).returns("Bye World")
        object = klass.new
        assert_equal "Bye World", object.my_method
      end
      assert_passed(test_result)
    end

    object = klass.new
    assert_equal "Hello World", object.my_method
  end
end
